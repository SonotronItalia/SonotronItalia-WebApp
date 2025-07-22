# Comandi frontend
FRONTEND_DIR=frontend
BACKEND_DIR=backend

.PHONY: all setup dev backup-db restore-db

# ✅ Setup completo: installa deps, crea .env e ripristina db
setup:
	@echo "🔧 Setup BACKEND..."
	$(MAKE) -C $(BACKEND_DIR) setup

	@echo "📦 Installazione dipendenze FRONTEND..."
	@if [ ! -d $(FRONTEND_DIR)/node_modules ]; then \
		cd $(FRONTEND_DIR) && npm install; \
	else \
		echo "ℹ️  Dipendenze frontend già installate."; \
	fi

	@echo "✅ Setup completato."

# ✅ Avvio server Next.js + Strapi insieme
dev:
	@echo "🚀 Avvio Frontend e Backend..."
	npx concurrently \
		"cd $(FRONTEND_DIR) && npm run dev" \
		"cd $(BACKEND_DIR) && npm run develop"

# ✅ Backup del database
backup-db:
	@$(MAKE) -C $(BACKEND_DIR) backup

# ✅ Restore del database
restore-db:
	@$(MAKE) -C $(BACKEND_DIR) restore
