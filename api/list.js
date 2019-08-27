const instruments = require('./instruments.json')

function listInstruments({q}) {
  return instruments.filter(x => !q || x.id.includes(q.toUpperCase()) || x.name.toUpperCase().includes(q.toUpperCase()))
  .map(x => ({
    id: x.id,
    name: x.name,
    price: x.price
  }))
}

module.exports = listInstruments