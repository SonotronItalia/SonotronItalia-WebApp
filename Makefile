# Comandi frontend
FRONTEND_DIR=sonotron-frontend
BACKEND_DIR=sonotron-backend

DB_FILE=sonotron-backend/.tmp/data.db
ZIP_FILE=sonotron-backend/db_backup.zip

FRONTEND_PID=.frontend.pid
BACKEND_PID=.backend.pid

.PHONY: all setup dev stop backup restore

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


# 🛑 Stop frontend + backend usando i PID salvati
stop:
	@echo "🛑 Arresto processi..."
	@if [ -f $(FRONTEND_PID) ]; then \
		kill `cat $(FRONTEND_PID)` && rm -f $(FRONTEND_PID) && echo "✔️  Frontend fermato."; \
	else \
		echo "ℹ️  Nessun frontend da fermare."; \
	fi

	@if [ -f $(BACKEND_PID) ]; then \
		kill `cat $(BACKEND_PID)` && rm -f $(BACKEND_PID) && echo "✔️  Backend fermato."; \
	else \
		echo "ℹ️  Nessun backend da fermare."; \
	fi



# ✅ Comprime il database
backup:
	@echo "🔄 Creazione archivio $(ZIP_FILE)..."
	@if [ -f $(DB_FILE) ]; then \
		zip -j $(ZIP_FILE) $(DB_FILE); \
		echo "✅ Backup creato in $(ZIP_FILE)"; \
	else \
		echo "❌ File $(DB_FILE) non trovato."; \
	fi

# ✅ Estrae e sostituisce il database
restore:
	@echo "📦 Ripristino database da $(ZIP_FILE)..."
	@if [ -f $(ZIP_FILE) ]; then \
		unzip -o $(ZIP_FILE) -d .; \
		mv $(DB_FILE) .tmp/ \
		echo "✅ $(DB_FILE) ripristinato."; \
	else \
		echo "❌ File $(ZIP_FILE) non trovato."; \
	fi
