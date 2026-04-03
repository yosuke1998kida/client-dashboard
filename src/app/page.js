import styles from './page.module.css'

const TEST_CLIENT = {
  companyName: 'テスト株式会社',
  plan: 'スタンダードプラン',
  contractStart: '2026-01-01',
  kpis: [
    { label: '月間売上', value: '¥12,500,000', target: '¥15,000,000', progress: 83, trend: 'up' },
    { label: 'リード獲得数', value: '142件', target: '200件', progress: 71, trend: 'up' },
    { label: 'コンバージョン率', value: '3.2%', target: '4.0%', progress: 80, trend: 'flat' },
    { label: '顧客満足度', value: '4.3 / 5.0', target: '4.5', progress: 96, trend: 'up' },
  ],
  tasks: [
    { title: 'LP改善A/Bテスト実施', status: 'completed', date: '2026-03-28' },
    { title: 'SNS広告クリエイティブ更新', status: 'in_progress', date: '2026-04-01' },
    { title: 'メルマガ配信（4月号）', status: 'pending', date: '2026-04-07' },
  ],
  reports: [
    { title: '3月度月次レポート', date: '2026-04-01', type: 'monthly' },
    { title: 'Q1四半期レポート', date: '2026-04-02', type: 'quarterly' },
  ],
}

const STATUS_LABELS = {
  completed: '完了',
  in_progress: '進行中',
  pending: '未着手',
}

const STATUS_COLORS = {
  completed: '#22c55e',
  in_progress: '#3b82f6',
  pending: '#9ca3af',
}

const TREND_ARROWS = {
  up: '\u2191',
  down: '\u2193',
  flat: '\u2192',
}

export default function Home() {
  const client = TEST_CLIENT

  return (
    <main className={styles.main}>
      <div className={styles.container}>
        <header className={styles.header}>
          <h1 className={styles.title}>ICHIZEN Client Dashboard</h1>
          <div className={styles.clientInfo}>
            <span className={styles.companyName}>{client.companyName}</span>
            <span className={styles.plan}>{client.plan}</span>
          </div>
        </header>

        <section className={styles.section}>
          <h2 className={styles.sectionTitle}>KPI Overview</h2>
          <div className={styles.grid}>
            {client.kpis.map((kpi) => (
              <div key={kpi.label} className={styles.card}>
                <div className={styles.kpiLabel}>{kpi.label}</div>
                <div className={styles.kpiValue}>
                  {kpi.value}
                  <span className={styles.trend} data-trend={kpi.trend}>
                    {TREND_ARROWS[kpi.trend]}
                  </span>
                </div>
                <div className={styles.kpiTarget}>目標: {kpi.target}</div>
                <div className={styles.progressBar}>
                  <div
                    className={styles.progressFill}
                    style={{ width: `${kpi.progress}%` }}
                  />
                </div>
                <div className={styles.progressText}>{kpi.progress}%</div>
              </div>
            ))}
          </div>
        </section>

        <div className={styles.twoColumn}>
          <section className={styles.section}>
            <h2 className={styles.sectionTitle}>Tasks</h2>
            <ul className={styles.taskList}>
              {client.tasks.map((task) => (
                <li key={task.title} className={styles.taskItem}>
                  <span
                    className={styles.statusDot}
                    style={{ backgroundColor: STATUS_COLORS[task.status] }}
                  />
                  <div className={styles.taskContent}>
                    <div className={styles.taskTitle}>{task.title}</div>
                    <div className={styles.taskMeta}>
                      {STATUS_LABELS[task.status]} | {task.date}
                    </div>
                  </div>
                </li>
              ))}
            </ul>
          </section>

          <section className={styles.section}>
            <h2 className={styles.sectionTitle}>Reports</h2>
            <ul className={styles.taskList}>
              {client.reports.map((report) => (
                <li key={report.title} className={styles.taskItem}>
                  <span className={styles.reportIcon}>
                    {report.type === 'quarterly' ? 'Q' : 'M'}
                  </span>
                  <div className={styles.taskContent}>
                    <div className={styles.taskTitle}>{report.title}</div>
                    <div className={styles.taskMeta}>{report.date}</div>
                  </div>
                </li>
              ))}
            </ul>
          </section>
        </div>

        <footer className={styles.footer}>
          <p>Powered by ICHIZEN Holdings | Last updated: {new Date().toLocaleDateString('ja-JP')}</p>
        </footer>
      </div>
    </main>
  )
}
