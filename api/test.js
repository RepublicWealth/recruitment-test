const listInstruments = require('./list')
const brokerage = require('./brokerage')



console.log(JSON.stringify(listInstruments({}), null, 4))
console.log(JSON.stringify(listInstruments({q:"fi"}), null, 4))


console.log(JSON.stringify(brokerage.additional({fundId: "FUND1", units: "100"}), null, 4))
console.log(JSON.stringify(brokerage.additional({fundId: "FUND2", units: "100"}), null, 4))

console.log(JSON.stringify(brokerage.inclusive({fundId: "FUND1", amount: "10000"}), null, 4))
console.log(JSON.stringify(brokerage.inclusive({fundId: "FUND2", amount: "10000"}), null, 4))
