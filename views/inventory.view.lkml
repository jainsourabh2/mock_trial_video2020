view: inventory {
  sql_table_name: sakila.inventory ;;
  drill_fields: [inventory_id]

  dimension: inventory_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.inventory_id ;;
  }

  dimension: film_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.film_id ;;
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
    type: number
    sql: ${TABLE}.store_id ;;
    link: {
      label: "Store Dashboard for Operations"
      url: "https://emcedev.cloud.looker.com/dashboards-next/54?Store%20ID={{ filterable_value | url_encode }}"
    }
  }

  measure: count {
    type: count
    drill_fields: [inventory_id, film.film_id, rental.count]
  }

  measure: total_inventory {
    type: count
  }
}
