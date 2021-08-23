view: payment {
  sql_table_name: sakila.payment ;;
  drill_fields: [payment_id]

  dimension: payment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.payment_id ;;
  }

  dimension: amount {
    hidden: yes
    type: number
    sql: ${TABLE}.amount;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: last_update {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_update ;;
  }

  dimension_group: payment {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.payment_date ;;
  }

  dimension: rental_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.rental_id ;;
  }

  dimension: staff_id {
    type: yesno
    sql: ${TABLE}.staff_id ;;
  }

  dimension: months_since_signup {
    type: number
    sql: TIMESTAMPDIFF(month, customer_360.first_rental_date, ${payment_date})  ;;
  }

  measure: count {
    type: count
    drill_fields: [payment_id, rental.rental_id]
  }

  measure: total_payment {
    type: sum
    sql: ${amount} ;;
    #value_format_name: usd
    value_format: "0.00,\" K\""
  }

  measure: average_revenue_per_rental {
    type: average
    sql: ${amount} ;;
    value_format_name: usd
  }

  measure: unique_users {
    type: count_distinct
    sql: ${customer_id} ;;
  }

  measure: average_revenue_per_user {
    type: number
    sql: ${total_payment}/${unique_users} ;;
    value_format_name: usd
  }
}
