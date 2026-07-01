import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Gérer CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 1. Lire le corps brut de la requête (nécessaire pour la vérification de signature si configurée)
    const rawBody = await req.text()
    const payload = JSON.parse(rawBody)

    console.log("Webhook IzichangePay reçu :", payload)

    const event = payload.event
    const data = payload.data

    if (!event || !data) {
      throw new Error("Payload de Webhook invalide")
    }

    // 2. Récupération des variables d'environnement
    const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? ""
    const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ""
    const WEBHOOK_SECRET = Deno.env.get('IZICHANGE_WEBHOOK_SECRET') ?? ""

    // 3. Optionnel : Vérification de signature si le secret est configuré
    if (WEBHOOK_SECRET) {
      const signature = req.headers.get('X-IziPay-Signature') ?? ""
      console.log(`Vérification de la signature: ${signature}`)
      // Ici, on pourrait ajouter l'HMAC-SHA256 de verification.
      // Pour l'instant, on loggue pour faciliter le débogage.
    }

    // 4. Initialisation du client Supabase
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

    // 5. Traitement de la confirmation de paiement
    if (event === "payment_intent.completed" || data.status === "completed" || data.status === "paid") {
      const orderId = data.merchantReference

      if (!orderId) {
        throw new Error("Référence marchand (orderId) manquante dans le webhook")
      }

      console.log(`Paiement réussi pour la commande: ${orderId}. Mise à jour du statut...`)

      // Mettre à jour l'état de la commande à 'paid' dans la table orders
      const { error: orderError } = await supabase
        .from('orders')
        .update({ payment_status: 'paid', updated_at: new Date().toISOString() })
        .eq('id', orderId)

      if (orderError) {
        throw new Error(`Erreur lors de la mise à jour de la commande: ${orderError.message}`)
      }

      // Mettre à jour la transaction correspondante
      const { error: txError } = await supabase
        .from('transactions')
        .update({ status: 'paid' })
        .eq('order_id', orderId)

      if (txError) {
        console.error(`Erreur lors de la mise à jour de la transaction: ${txError.message}`)
      }

      return new Response(
        JSON.stringify({ success: true, message: `Commande ${orderId} marquée comme payée.` }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
      )
    }

    return new Response(
      JSON.stringify({ success: true, message: `Événement ${event} ignoré.` }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )

  } catch (error) {
    console.error("Erreur Webhook:", error.message)
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
    )
  }
})
