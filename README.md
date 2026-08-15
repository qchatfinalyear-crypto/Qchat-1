# QChat — React + Vite + Convex + Besu

## Windows setup (after migrating from Linux)

### Prerequisites

1. **Node.js** (recommended: install system-wide with Administrator approval):
   ```powershell
   winget install OpenJS.NodeJS.LTS
   ```
   If Node is not on your PATH yet, `scripts/ensure-node.ps1` can download a portable Node.js install automatically.

2. **Docker Desktop** (replaces Podman from Fedora for the local Besu blockchain):
   https://docs.docker.com/desktop/setup/install/windows-install/

3. **Convex account** — same deployment you used on Linux.

### One-time setup

```powershell
cd C:\Users\ERASTUS\Desktop\Qchat
pnpm run setup:windows
```

Copy your Convex URL into `.env.local` (see `.env.example`). If you no longer have the Linux `.env.local`, run `npx convex dev` and it will create/link the deployment and write the URL for you.

### Run the app

Terminal 1 — Convex backend sync:
```powershell
npx convex dev
```

Terminal 2 — Besu blockchain + Vite frontend:
```powershell
pnpm run start:windows
```

Or start only the frontend (without Besu):
```powershell
pnpm dev
```

### Linux/Fedora

Use `./start-project.sh` (requires Podman). See `contract/README.md` for smart-contract deployment.

---

## React + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Oxc](https://oxc.rs)
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/)

## React Compiler

The React Compiler is enabled on this template. See [this documentation](https://react.dev/learn/react-compiler) for more information.

Note: This will impact Vite dev & build performances.

## Expanding the ESLint configuration

If you are developing a production application, we recommend using TypeScript with type-aware lint rules enabled. Check out the [TS template](https://github.com/vitejs/vite/tree/main/packages/create-vite/template-react-ts) for information on how to integrate TypeScript and [`typescript-eslint`](https://typescript-eslint.io) in your project.
