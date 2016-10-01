// Credits to Zeroskillz ! Check him in -> https://www.reddit.com/user/zeroskillz

class FakeCoins {
  constructor(coins) {
    this.coins = coins
    this.map = new Map()
  }

  parse() {
    this.coins.split('\n').forEach(i => {
      let row = i.split(' ')

      if (row.pop() === 'equal') {
        this.equal(row)
      } else {
        this.fake(row)
      }
    })

    return this.eval()
  }

  equal(row) {
    row.forEach(i => i.split('').forEach(j => this.set(j, 2)))
  }

  fake(row) {
    row.shift().split('').forEach(i => this.set(i, 2))

    row.shift().split('').forEach(i => {
      if (!this.has(i)) {
        this.set(i, 1)
      } else if(this.get(i) === 2) {
        this.set(i, -1)
      }
    })
  }

  set(i, amount) {
    this.map.set(i, amount)
  }

  get(i) {
    return this.map.get(i)
  }

  has(i) {
    return this.map.has(i)
  }

  eval() {
    let e = [],
        inc = false

    this.map.forEach((v, i) => {
      if (v === 1) {
        e.push(i)
      } else if(v === -1) {
        inc = true
      }
    })

    if (e.length === 1) {
      console.log(`${e.pop()} is lighter`)
    } else if(inc) {
      console.log('data is inconsistent')
    } else { 
      console.log('no fake coins detected')
    }
  }
}