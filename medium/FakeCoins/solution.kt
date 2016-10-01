import java.io.File
import java.util.*

// Credits to j_selby ! Check him on -> https://www.reddit.com/user/j_selby

data class Coin(val char : Char/*mander*/) {
    val lighterThan = ArrayList<Array<Coin>>()
    val equalTo = ArrayList<Array<Coin>>()

    fun removeSelf(initiate : Coin, list: MutableList<Coin>) {
        // Remove coin, anything ==, and anything heavier
        list.remove(this)

        for (removeCoinList in lighterThan) {
            for (removeCoin in removeCoinList) {
                if (list.contains(removeCoin)) {
                    if (removeCoin == initiate) {
                        throw InconsistentDataException("Coin which triggered removal" +
                                " ($initiate) is removing itself recursively (in a lighter than stage)")
                    }
                    removeCoin.removeSelf(initiate, list)
                }
            }
        }
        for (removeCoinList in equalTo) {
            for (removeCoin in removeCoinList) {
                if (list.contains(removeCoin)) {
                    if (removeCoin == initiate) {
                        throw InconsistentDataException("Coin which triggered removal" +
                                " ($initiate) is removing itself recursively (in a equal stage)")
                    }
                    removeCoin.removeSelf(initiate, list)
                }
            }
        }
    }
}

enum class ScaleState {
    LEFT, RIGHT, EQUAL
}

class InconsistentDataException(reason : String) : RuntimeException(reason)

class CoinSorter {
    private val coinMap = mutableMapOf<Char, Coin>()

    fun getCoin(char : Char) = coinMap.getOrPut(char, {Coin(char)})

    fun getCoins() = coinMap.values.toMutableList()

    fun parse(line : String) {
        // Convert
        val (scaleLeftRaw, scaleRightRaw, stateRaw) = line.trim().split(" ")
        val state = ScaleState.valueOf(stateRaw.toUpperCase())
        val scaleLeft = scaleLeftRaw.toCharArray().map { getCoin(it) }.toTypedArray()
        val scaleRight = scaleRightRaw.toCharArray().map { getCoin(it) }.toTypedArray()

        // Sort
        when (state) {
            ScaleState.LEFT -> {
                // Left is heavier
                for (coin in scaleRight) {
                    coin.lighterThan.add(scaleLeft)
                }
            }
            ScaleState.RIGHT -> {
                // Right is heavier
                for (coin in scaleLeft) {
                    coin.lighterThan.add(scaleRight)
                }
            }
            ScaleState.EQUAL -> {
                for (coin in scaleLeft) {
                    coin.equalTo.add(scaleRight)
                }

                for (coin in scaleRight) {
                    coin.equalTo.add(scaleLeft)
                }
            }
        }
    }
}

fun main(args : Array<String>) {
    val coinHandler = CoinSorter()

    File("input.txt").forEachLine {
        coinHandler.parse(it)
    }

    // Check coins
    val list = coinHandler.getCoins()
    val originalList = list.distinct()

    for (coin in originalList) {
        for (otherCoin in list) {
            if (otherCoin.lighterThan
                    .filter { it.contains(coin) }
                    .isNotEmpty()) {
                try {
                    coin.removeSelf(otherCoin, list)
                } catch (e : InconsistentDataException) {
                    println("data is inconsistent (${e.message})")
                    return
                }
                break
            }
        }
    }

    if (list.size != 0 && originalList.minus(list).size > 0) {
        println("${list.map { it.char }} is lighter")
    } else {
        println("no fake coins detected")
    }
}