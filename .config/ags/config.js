const entry = `${App.configDir}/ts/main.ts`
const outdir = '/tmp/ags/js'

try {
  await Utils.execAsync([
    'bun', 'build', entry,
    '--outdir', outdir,
    '--external', 'resources://*',
    '--external', 'gi://*'
  ])
  await import(`file://${outdir}/main.js`)
} catch (err) {
  console.error(err)
}

export {}
