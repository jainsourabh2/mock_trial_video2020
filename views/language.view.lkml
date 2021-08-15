view: language {
  sql_table_name: sakila.language ;;
  drill_fields: [language_id]

  dimension: language_id {
    primary_key: yes
    type: yesno
    sql: ${TABLE}.language_id ;;
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

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  measure: count {
    type: count
    drill_fields: [language_id, name]
  }
}
