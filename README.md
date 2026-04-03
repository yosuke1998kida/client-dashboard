# ICHIZEN Client Dashboard

クライアント向けダッシュボード（Next.js + Vercel）

## セットアップ

```bash
npm install
npm run dev
```

## デプロイ

Vercelと連携済み。`main`ブランチへのpushで自動デプロイされます。

### 手動セットアップ（初回のみ）

```bash
# Vercel CLIでログイン
npx vercel login

# Vercelプロジェクト作成＆GitHub連携
./scripts/setup-vercel.sh
```

## 構成

- `src/app/` - Next.js App Router ページ
- `src/app/api/` - API Routes
- `src/components/` - 共通コンポーネント
- `vercel.json` - Vercelデプロイ設定

## API

- `GET /api/health` - ヘルスチェック
