-- Script de création des tables pour l'application FoodChain

-- 1. Table des Commandes (Orders)
CREATE TABLE IF NOT EXISTS public.orders (
    id TEXT PRIMARY KEY, -- Référence de commande (ex: FC-9831A ou UUID)
    user_id TEXT, -- Identifiant de l'utilisateur (Mock ou UUID auth.users)
    restaurant_name TEXT NOT NULL,
    items JSONB NOT NULL, -- Liste des plats commandés [ { "name": "Burger", "price": 4500, "quantity": 2 } ]
    total_amount NUMERIC NOT NULL, -- Montant total payé dans la devise d'origine
    currency TEXT NOT NULL, -- XOF, BTC, USD
    payment_method TEXT NOT NULL, -- 'lightning', 'mobile_money', 'bitcoin'
    payment_status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'paid', 'expired', 'failed'
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Table des Transactions
CREATE TABLE IF NOT EXISTS public.transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id TEXT REFERENCES public.orders(id) ON DELETE CASCADE,
    payment_provider TEXT NOT NULL, -- 'izichange', 'lnbits', etc.
    provider_payment_id TEXT NOT NULL, -- ID de l'intention de paiement chez le fournisseur
    checkout_url TEXT, -- Lien de redirection vers la page de paiement Izichange
    payment_address TEXT, -- Adresse crypto si applicable
    amount NUMERIC NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Activation du temps réel (Realtime) sur la table 'orders'
-- Permet à l'application Flutter de recevoir instantanément une notification lorsque la commande est payée.
ALTER PUBLICATION supabase_realtime ADD TABLE public.orders;

-- 4. Droits d'accès RLS (Row Level Security) désactivés temporairement pour simplifier les tests
ALTER TABLE public.orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions DISABLE ROW LEVEL SECURITY;
