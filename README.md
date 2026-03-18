# ArchiMate MCP Server (Dockerized)

Ce projet fournit un serveur **Model Context Protocol (MCP)** permettant à des agents IA (comme Claude Desktop ou Langflow) d'interagir avec des modèles d'architecture **ArchiMate 3.2**.

Le serveur tourne dans un conteneur Docker pour isoler l'environnement et faciliter le déploiement.

## 🚀 Installation

### 1. Construire l'image Docker
Depuis la racine du projet, lancez la commande suivante :

```bash
docker build -t archimate-mcp-docker .
```

### 2. Structure du projet
- `Dockerfile` : Définit l'image basée sur Node.js 18-alpine.
- `models/` : Dossier contenant vos fichiers `.archimate` (ex: `ESSP_new_OR.archimate`).

---

## 🛠 Configuration MCP (Standard)

Pour utiliser ce serveur avec un client MCP classique (comme Claude Desktop), ajoutez cette configuration à votre fichier `config.json` :

```json
{
  "mcpServers": {
    "archimate": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-v", "/home/rmanoukhine/archimate-mcp-docker/models:/models",
        "archimate-mcp-docker"
      ]
    }
  }
}
```

---

## 🔗 Intégration Langflow (OpenRAG)

Pour utiliser ce serveur MCP à l'intérieur de votre infrastructure Langflow/OpenRAG, suivez ces étapes de configuration **Docker-out-of-Docker (DooD)**.

### Étape 1 : Partager le moteur Docker
Dans votre `docker-compose.yml` d'OpenRAG, ajoutez le socket Docker au service `langflow` :

```yaml
services:
  langflow:
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

### Étape 2 : Installer le client Docker dans Langflow
Une fois Langflow démarré, installez l'outil `docker` à l'intérieur du conteneur :

```bash
docker exec -u 0 -it langflow /bin/bash -c "apt-get update && apt-get install -y docker.io"
```

### Étape 3 : Configurer le serveur dans Langflow
Dans les réglages MCP de Langflow, utilisez les paramètres suivants :
- **Command** : `docker`
- **Arguments** :
  1. `run`
  2. `-i`
  3. `--rm`
  4. `-v`
  5. `/home/rmanoukhine/archimate-mcp-docker/models:/models`
  6. `archimate-mcp-docker`

---

## 📂 Utilisation du Modèle

Le modèle par défaut est situé à l'adresse interne : `/models/ESSP_new_OR.archimate`.

### Exemples de questions à poser à l'Agent :
- "Ouvre le modèle ArchiMate `/models/ESSP_new_OR.archimate` et liste les éléments de la couche Application."
- "Fais une analyse d'impact sur le composant 'Serveur X'."
- "Génère un diagramme Mermaid de la vue 'Architecture de Référence'."

---

## 📝 Outils Disponibles (32 outils)
Le serveur expose une API complète pour :
- **Navigation** : `archimate_list_elements`, `archimate_get_element`, `archimate_find_elements`.
- **Édition** : Création d'éléments par couche (Motivation, Strategy, Business, Application, Technology).
- **Relations** : Création et validation de relations ArchiMate 3.2.
- **Visualisation** : Export en Mermaid, SVG, PNG, Markdown ou HTML Deck.
- **Analyse** : Analyse d'impact (`archimate_impact_analysis`).

---

## 🛡 Sécurité
Le serveur utilise le montage de socket Docker (`/var/run/docker.sock`). Assurez-vous que votre environnement est sécurisé et ne l'utilisez pas sur des serveurs exposés publiquement sans protection adéquate.
