view: rental {
  sql_table_name: sakila.rental ;;
  drill_fields: [rental_id]

  dimension: rental_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.rental_id ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: inventory_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_id ;;
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

  dimension_group: rental {
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
    sql: ${TABLE}.rental_date ;;
  }

  dimension_group: return {
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
    sql: ${TABLE}.return_date ;;
  }

  dimension: staff_id {
    type: yesno
    sql: ${TABLE}.staff_id ;;
  }

  measure: count {
    type: count
    drill_fields: [rental_id, inventory.inventory_id, payment.count]
  }


  dimension: delayed_rental {
    hidden: yes
    type: number
    sql: datediff(IFNULL(${return_date},CURDATE()),${rental_date}) ;;
  }

  dimension: rental_duration {
    type: number
    sql: datediff(${return_date},${rental_date}) ;;
  }

  dimension: late_rental_hidden {
    hidden: yes
    type: yesno
    sql: ${delayed_rental} > 7  ;;
  }

  measure: late_rental  {
    type: count
    filters: [late_rental_hidden: "Yes"]
    drill_fields: [rental_id, rental_date,return_date]
  }

  measure: rented_inventory {
    type: count
    filters: [return_date: "NULL"]
    drill_fields: [rental_id,rental_date]
  }

  # dimension_group: return_rental {
  #   type: duration
  #   sql_start: ${customer.created_raw} ;;
  #   sql_end: ${rental_date} ;;
  # }

}
