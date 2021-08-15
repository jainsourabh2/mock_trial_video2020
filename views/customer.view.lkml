view: customer {
  sql_table_name: sakila.customer ;;
  drill_fields: [customer_id]

  dimension: customer_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: active {
    type: yesno
    sql: ${TABLE}.active ;;
  }

  dimension: address_id {
    type: number
    sql: ${TABLE}.address_id ;;
  }

  dimension_group: create {
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
    sql: ${TABLE}.create_date ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
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

  dimension: store_id {
    type: yesno
    sql: ${TABLE}.store_id ;;
  }

  measure: total_users {
    type: count
    drill_fields: [customer_id, first_name, last_name]
  }

  measure: active_users {
    type: sum
    filters: [active: "TRUE"]
    sql: CASE WHEN ${active}='TRUE' THEN 1 ELSE 0 END ;;
  }

  measure: inactive_users {
    type: count
    filters: [active: "FALSE"]
  }
}
