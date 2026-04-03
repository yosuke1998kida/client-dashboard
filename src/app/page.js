import styles from './page.module.css'

export default function Home() {
  return (
    <main className={styles.main}>
      <div className={styles.container}>
        <h1 className={styles.title}>ICHIZEN Client Dashboard</h1>
        <p className={styles.description}>
          クライアント向けダッシュボード
        </p>
        <div className={styles.grid}>
          <div className={styles.card}>
            <h2>KPI Overview</h2>
            <p>主要KPIの一覧と進捗状況</p>
          </div>
          <div className={styles.card}>
            <h2>Reports</h2>
            <p>レポート・分析結果の閲覧</p>
          </div>
          <div className={styles.card}>
            <h2>Tasks</h2>
            <p>タスク管理と進捗トラッキング</p>
          </div>
          <div className={styles.card}>
            <h2>Settings</h2>
            <p>アカウント・通知設定</p>
          </div>
        </div>
      </div>
    </main>
  )
}
