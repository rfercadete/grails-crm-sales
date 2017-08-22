package grails.plugins.crm.sales

/**
 * Created by goran on 2016-05-12.
 */
class CrmSalesProjectItem {

    public static final List<String> BIND_WHITELIST = ['orderIndex', 'productId', 'productName', 'comment',
            'unit', 'quantity', 'price', 'vat', 'discount'].asImmutable()

    Integer orderIndex
    String productId
    String productName
    String comment
    String unit
    Double quantity
    Double price
    Double vat
    Double discount

    static belongsTo = [project: CrmSalesProject]

    static constraints = {
        orderIndex()
        productId(maxSize: 40, blank: false)
        productName(maxSize: 255, blank: false)
        comment(maxSize: 255, nullable: true)
        unit(maxSize: 40, nullable: false, blank: false)
        quantity(nullable: false, min: -999999d, max: 999999d, scale: 2)
        discount(nullable: true, min: -999999d, max: 999999d, scale: 2)
        price(nullable: false, min: -999999d, max: 999999d, scale: 2)
        vat(nullable: false, min: 0d, max: 1d, scale: 2)
    }

    static transients = ['priceVAT', 'totalPrice', 'totalPriceVAT', 'totalVat', 'discountPrice', 'discountPriceVAT', 'empty', 'dao']

    transient Double getPriceVAT() {
        def p = price
        if (!p) {
            return 0
        }
        def v = vat ?: 0
        return p + (p * v)
    }

    transient Double getDiscountPrice() {
        def p = price
        if (!p) {
            return 0
        }
        def d = discount
        if (d) {
            if (d < 1) {
                p -= (p * d)
            } else {
                p -= d
            }
        }
        return p
    }

    transient Double getDiscountPriceVAT() {
        def p = getDiscountPrice()
        def v = vat ?: 0
        return p + (p * v)
    }

    transient Double getTotalVat() {
        getTotalPrice() * (vat ?: 0)
    }

    transient Double getTotalPrice() {
        def p = (quantity ?: 0) * (price ?: 0)
        def d = discount
        if (!d) {
            return p // No discount
        }
        if (d < 1) {
            return p - (d * p) // Percent discount
        }
        return p - d // Amount discount
    }

    transient Double getTotalPriceVAT() {
        def p = getTotalPrice()
        def v = vat ?: 0
        return p + (p * v)
    }

    /**
     * Return the discount amount, the amount to subtract from total price when applying discount.
     * If discount is less than 1 the discount is represented as percent (% discount),
     * otherwise it's the actual total discount amount for this order item.
     * @return the amount to subtract from totalPrice when applying discount
     */
    transient Double getDiscountValue() {
        def p = (quantity ?: 0) * (price ?: 0)
        def d = discount ?: 0
        return d < 1 ? (p * d) : d
    }

    transient Double getDiscountValueVAT() {
        def p = getDiscountValue()
        def v = vat ?: 0
        return p + (p * v)
    }

    String toString() {
        "$quantity $unit $productId"
    }

    transient boolean isEmpty() {
        if(productId != null) return false
        if(productName != null) return false
        if(comment != null) return false
        if(quantity != null) return false
        if(price != null) return false

        return true
    }

    transient Map<String, Object> getDao() {
        [orderIndex: orderIndex, productId: productId, productName: productName, comment: comment,
                quantity: quantity, unit: unit, vat: vat,
                price: price, priceVAT: getPriceVAT(),
                discount: discount, discountPrice: getDiscountPrice(), discountPriceVAT: getDiscountPriceVAT(),
                totalPrice: getTotalPrice(), totalPriceVAT: getTotalPriceVAT()]
    }
}
