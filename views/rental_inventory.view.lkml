view: rental_inventory {

  derived_table: {
    sql: SELECT
          rented_inventory.film_id as film_id,
          rented_inventory.films as rented_inventory,
          total_inventory.films as total_inventory
          FROM
          (

            Select
            film_id,
            count(*) as films
            FROM inventory
            JOIN rental on rental.inventory_id = inventory.inventory_id
            WHERE rental.return_date is NULL
            GROUP BY 1
          ) as rented_inventory
          LEFT JOIN
          (
            Select
            film_id,
            count(*) films
            FROM inventory
            GROUP BY 1
          ) as total_inventory
          ON rented_inventory.film_id = total_inventory.film_id
       ;;

      datagroup_trigger: inventory_dg
      indexes: ["film_id"]
      #sql_trigger_value: SELECT EXTRACT(MINUTE FROM CURRENT_TIMESTAMP()) ;;
    }

  dimension: film_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.film_id ;;
    hidden: yes
  }

  measure: total_inventory {
    type: sum
    sql:  ${TABLE}.total_inventory;;
  }

  measure: rented_inventory {
    type: sum
    sql: ${TABLE}.rented_inventory ;;
  }

  measure: available_inventory {
    type: number
    sql: ${total_inventory}-${rented_inventory} ;;
  }

}
