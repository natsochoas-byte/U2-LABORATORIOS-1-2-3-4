// Actividad 1
db.version()
db.adminCommand({ getCmdLineOpts: 1 })
db.adminCommand({ getParameter: 1, featureCompatibilityVersion: 1 })
db.runCommand({ connectionStatus: 1 })

// Actividad 2
db.getProfilingStatus()
db.system.profile.countDocuments()

// Actividad 3
db.setProfilingLevel(2)
db.getProfilingStatus()
db.system.profile.find().sort({ ts: 1 }).toArray()

// Actividad 4
db.setProfilingLevel(0)
db.system.profile.drop()
db.setProfilingLevel(1, {
  filter: { op: { $in: ["insert", "update", "remove"] } }
})
db.getProfilingStatus()
db.system.profile.find().sort({ ts: 1 }).toArray()

// Actividad 5
function bitacora() {
  return db.adminCommand({ getLog: "global" }).log.map(l => JSON.parse(l))
}
bitacora().filter(e => JSON.stringify(e).includes("AuthenticationFailed"))
bitacora().filter(e => JSON.stringify(e).includes("UserNotFound"))
bitacora().filter(e => JSON.stringify(e).includes("Successfully authenticated"))

// Actividad 6
bitacora().filter(e => JSON.stringify(e).includes("Profiler settings changed"))
bitacora().filter(e => JSON.stringify(e).includes("Successfully authenticated"))

// Actividad 7
db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({
    user: u.user,
    db: u.db,
    roles: u.roles
  }))
})

db.grantRolesToUser("app_ventas", [
  { role: "dbAdmin", db: "comercial" }
])

db.revokeRolesFromUser("app_ventas", [
  { role: "dbAdmin", db: "comercial" }
])

db.setProfilingLevel(1, {
  filter: { op: { $in: ["insert", "update", "remove"] } }
})

// Actividad 8
db.getProfilingStatus()
db.system.profile.countDocuments()
bitacora().length

// Actividad 9
db.getSiblingDB("auditoria").instantaneas_privilegios.find().sort({
  momento: 1
}).toArray()

// Actividad 10
db.system.profile.find().sort({ ts: 1 }).toArray()