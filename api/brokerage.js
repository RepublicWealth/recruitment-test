const instruments = require('./instruments.json')

function additional({fundId, units}) {
  const fund = instruments.find(x => x.id === fundId)
  const basePrice = units * fund.price
  const brokerage = fund.brokerageAmount !== undefined ? fund.brokerageAmount * 1 : fund.brokerageRate * basePrice

  return {
    fundId,
    units: units * 1,
    basePrice,
    brokerage,
    totalPrice: basePrice + brokerage
  }
}  

function inclusive({fundId, amount}) {
  const fund = instruments.find(x => x.id === fundId)

  const estimatedBrokerage = fund.brokerageAmount !== undefined ? fund.brokerageAmount * 1  : fund.brokerageRate * amount

  const units = Math.floor((amount - estimatedBrokerage) / fund.price)

  const basePrice = units * fund.price 

  const actualBrokerage = fund.brokerageAmount !== undefined ? fund.brokerageAmount * 1 : fund.brokerageRate * basePrice

  return {
    fundId,
    units,
    basePrice,
    brokerage: actualBrokerage,
    totalPrice: basePrice + actualBrokerage
  }
}  


module.exports = {
  additional,
  inclusive
}
