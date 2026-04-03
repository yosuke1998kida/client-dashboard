export const metadata = {
  title: 'ICHIZEN Client Dashboard',
  description: 'ICHIZEN Holdings - クライアントダッシュボード',
}

export default function RootLayout({ children }) {
  return (
    <html lang="ja">
      <body>{children}</body>
    </html>
  )
}
