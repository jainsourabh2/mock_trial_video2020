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

  measure: returned_rentals {
    type: count
    filters: [return_date: "-NULL"]
    drill_fields: [rental_id,rental_date]
  }

  measure: average_rental_duration {
    type: average
    sql: ${rental_duration} ;;
  }

  # dimension_group: return_rental {
  #   type: duration
  #   sql_start: ${customer_360.first_rental_date_raw} ;;
  #   sql_end: ${rental_date} ;;
  # }


  dimension: days_until_2nd_rental {
    view_label: "Repeat Rental"
    type: number
    sql: DATEDIFF(${repeat_rentals.rental_date_after1_rental_raw}, ${rental_date}) ;;
  }

  # dimension: days_until_3nd_rental {
  #   view_label: "Repeat Rental"
  #   type: number
  #   sql: DATEDIFF(${repeat_rentals.rental_date_after2_rental_raw}, ${rental_date}) ;;
  # }


  dimension: 2nd_rental_30d {
    label: "Has Repeat Rental Within 30d"
    type: yesno
    view_label: "Repeat Rental"
    sql: ${days_until_2nd_rental} <= 30 ;;
  }

  measure: 2nd_rental_within_30d {
    type: count_distinct
    sql: ${rental_id} ;;
    view_label: "Repeat Rental"

    filters: {
      field: 2nd_rental_30d
      value: "Yes"
    }
  }

  measure: repeat_rental_rate {
    view_label: "Repeat Rental"
    type: number
    value_format_name: percent_1
    sql: ${2nd_rental_within_30d} / ${count}  ;;
  }

}
