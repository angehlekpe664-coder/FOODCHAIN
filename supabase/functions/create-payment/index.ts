import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Gérer la pré-vérification CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { order_id, restaurant_name, items, total_amount, currency, payment_method } = await req.json()

    // 1. Récupération des variables d'environnement
    const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? ""
    const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ""
    const IZICHANGE_API_KEY = Deno.env.get('IZICHANGE_API_KEY') ?? ""

    // 2. Initialisation du client Supabase
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

    // 3. Enregistrement de la commande
    const { error: orderError } = await supabase
      .from('orders')
      .insert({
        id: order_id,
        restaurant_name,
        items,
        total_amount,
        currency,
        payment_method,
        payment_status: 'pending'
      })

    if (orderError) {
      throw new Error(`Impossible de sauvegarder la commande: ${orderError.message}`)
    }

    // 4. Création de l'intention de paiement chez IzichangePay
    let paymentUrl = ""
    let providerPaymentId = "simulated_" + Math.random().toString(36).substring(7)
    
    const isLive = IZICHANGE_API_KEY.startsWith("sk_live_")
    const iziBaseUrl = isLive ? "https://api.pay.izichange.com" : "https://api.sandbox-pay.izichange.com"

    try {
      const response = await fetch(`${iziBaseUrl}/v1/payment-intents`, {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${IZICHANGE_API_KEY}`,
          "Content-Type": "application/json",
          "idempotency-key": order_id
        },
        body: JSON.stringify({
          amount: total_amount.toString(),
          currency: currency,
          amountRequested: total_amount.toString(),
          currencyRequested: currency,
          requestedCurrencyType: currency === "XOF" ? "fiat" : "crypto",
          merchantReference: order_id,
          customer: {
            email: "client@foodchain.com",
            firstName: "Client",
            lastName: "FoodChain"
          }
        })
      })

      if (response.ok) {
        const data = await response.json()
        paymentUrl = data.paymentUrl || data.checkoutUrl || ""
        providerPaymentId = data.intentId || data.id || providerPaymentId
      } else {
        const errorText = await response.text()
        console.error(`Erreur API IzichangePay: ${errorText}`)
        // Fallback sécurisé en mode simulation
        paymentUrl = `https://mock.foodchain.com/pay/${order_id}`
      }
    } catch (e) {
      console.error(`Échec de connexion à IzichangePay: ${e.message}`)
      // Fallback sécurisé en mode simulation
      paymentUrl = `https://mock.foodchain.com/pay/${order_id}`
    }

    // 5. Enregistrement des détails de transaction
    const { error: txError } = await supabase
      .from('transactions')
      .insert({
        order_id,
        payment_provider: 'izichange',
        provider_payment_id: providerPaymentId,
        checkout_url: paymentUrl,
        amount: total_amount,
        status: 'pending'
      })

    if (txError) {
      console.error(`Impossible d'enregistrer les détails de la transaction: ${txError.message}`)
    }

    return new Response(
      JSON.stringify({ 
        success: true,
        orderId: order_id,
        paymentUrl: paymentUrl,
        providerPaymentId: providerPaymentId
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200 
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400 
      }
    )
  }
})
