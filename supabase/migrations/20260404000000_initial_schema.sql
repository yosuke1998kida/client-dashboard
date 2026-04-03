-- ============================================================
-- client-dashboard 初期スキーマ
-- テーブル: clients, kpis, tasks, reports
-- RLS（Row Level Security）有効化
-- ============================================================

-- =========================
-- 1. clients テーブル
-- =========================
CREATE TABLE IF NOT EXISTS clients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_name TEXT NOT NULL,
  plan TEXT NOT NULL DEFAULT 'スタンダードプラン',
  contract_start DATE NOT NULL,
  contract_end DATE,
  contact_email TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE clients IS 'クライアント（顧客企業）マスタ';
COMMENT ON COLUMN clients.plan IS '契約プラン名（スタンダード/プレミアム等）';

-- =========================
-- 2. kpis テーブル
-- =========================
CREATE TYPE kpi_trend AS ENUM ('up', 'down', 'flat');

CREATE TABLE IF NOT EXISTS kpis (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  label TEXT NOT NULL,
  value TEXT NOT NULL,
  target TEXT NOT NULL,
  progress INTEGER NOT NULL DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
  trend kpi_trend NOT NULL DEFAULT 'flat',
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE kpis IS 'クライアントごとのKPI実績';
COMMENT ON COLUMN kpis.progress IS '達成率（0-100%）';
COMMENT ON COLUMN kpis.trend IS 'トレンド方向（up/down/flat）';

CREATE INDEX idx_kpis_client_id ON kpis(client_id);
CREATE INDEX idx_kpis_period ON kpis(period_start, period_end);

-- =========================
-- 3. tasks テーブル
-- =========================
CREATE TYPE task_status AS ENUM ('pending', 'in_progress', 'completed', 'cancelled');

CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  status task_status NOT NULL DEFAULT 'pending',
  due_date DATE,
  completed_at TIMESTAMPTZ,
  assignee TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE tasks IS 'クライアント向け施策タスク';

CREATE INDEX idx_tasks_client_id ON tasks(client_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);

-- =========================
-- 4. reports テーブル
-- =========================
CREATE TYPE report_type AS ENUM ('monthly', 'quarterly', 'yearly', 'adhoc');

CREATE TABLE IF NOT EXISTS reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  report_type report_type NOT NULL DEFAULT 'monthly',
  report_date DATE NOT NULL,
  file_url TEXT,
  summary TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE reports IS 'クライアント向けレポート';

CREATE INDEX idx_reports_client_id ON reports(client_id);
CREATE INDEX idx_reports_date ON reports(report_date);

-- =========================
-- 5. updated_at 自動更新トリガー
-- =========================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_clients_updated_at
  BEFORE UPDATE ON clients
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_kpis_updated_at
  BEFORE UPDATE ON kpis
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_tasks_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_reports_updated_at
  BEFORE UPDATE ON reports
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- =========================
-- 6. RLS（Row Level Security）有効化
-- =========================
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE kpis ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- サービスロール（API経由）は全アクセス可能
CREATE POLICY "Service role full access on clients"
  ON clients FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on kpis"
  ON kpis FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on tasks"
  ON tasks FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on reports"
  ON reports FOR ALL
  USING (auth.role() = 'service_role');

-- 認証ユーザーは読み取りのみ（ダッシュボード表示用）
CREATE POLICY "Authenticated users can read clients"
  ON clients FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read kpis"
  ON kpis FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read tasks"
  ON tasks FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read reports"
  ON reports FOR SELECT
  USING (auth.role() = 'authenticated');
