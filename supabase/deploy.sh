#!/bin/bash

# Script de déploiement pour le backend FoodChain Supabase

PROJECT_REF="ejrmrgflrgbmuyusionm"

# Récupérer la clé secrète IzichangePay (depuis une variable d'env, ou via saisie utilisateur)
if [ -z "$IZICHANGE_KEY" ]; then
    read -sp "🔑 Veuillez entrer votre clé secrète IzichangePay (la saisie sera masquée) : " IZICHANGE_KEY
    echo ""
fi

echo "=========================================================="
echo "🚀 Déploiement du Backend FoodChain sur Supabase"
echo "=========================================================="

# 1. Vérifier si Supabase CLI est installé
if ! command -v supabase &> /dev/null
then
    echo "❌ Le CLI Supabase n'est pas installé."
    echo "Veuillez l'installer avec : npm install -g supabase"
    exit 1
fi

# 2. Liaison au projet Supabase
echo "🔗 Liaison au projet Supabase ($PROJECT_REF)..."
supabase link --project-ref "$PROJECT_REF"

# 3. Définir le secret API IzichangePay sur Supabase
echo "🔑 Configuration de la clé secrète IzichangePay..."
supabase secrets set IZICHANGE_API_KEY="$IZICHANGE_KEY"

# 4. Déploiement des Edge Functions
echo "📦 Déploiement de 'create-payment'..."
supabase functions deploy create-payment --project-ref "$PROJECT_REF"

echo "📦 Déploiement de 'izichange-webhook'..."
supabase functions deploy izichange-webhook --project-ref "$PROJECT_REF"

echo "=========================================================="
echo "✅ Backend déployé avec succès !"
echo "👉 Webhook URL pour ton Dashboard IzichangePay :"
echo "https://$PROJECT_REF.supabase.co/functions/v1/izichange-webhook"
echo "=========================================================="
