view: repeat_rentals {
  derived_table: {
    sql: SELECT  rental.customer_id,
                rental.rental_id,
                rental.rental_date,
                count(distinct rental_2nd.rental_id) AS number_subsequent_rentals_after1,
                min(rental_2nd.rental_date) AS next_rental_date_after1,
                min(rental_2nd.rental_id) AS next_rental_id_after1,
                count(distinct rental_3rd.rental_id) AS number_subsequent_rentals_after2,
                min(rental_3rd.rental_date) AS next_rental_date_after2,
                min(rental_3rd.rental_id) AS next_rental_id_after2
        FROM sakila.rental AS rental
          LEFT JOIN sakila.rental AS rental_2nd ON rental_2nd.customer_id = rental.customer_id
                                                      AND rental_2nd.rental_date > rental.rental_date
          LEFT JOIN sakila.rental AS rental_3rd ON rental_3rd.customer_id = rental_2nd.customer_id
                                                      AND rental_3rd.rental_date > rental_2nd.rental_date
        GROUP BY
          1, 2, 3  ;;

      datagroup_trigger: repeat_rentals_dg
      indexes: ["rental_id"]
    }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [detail*]
  }

  dimension: rental_id {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.rental_id ;;
  }

  dimension_group: rental_date {
    type: time
    sql: ${TABLE}.rental_date ;;
  }

  dimension: rental_id_after1_rental {
    type: number
    hidden:  yes
    sql: ${TABLE}.next_rental_id_after1 ;;
  }

  dimension_group: rental_date_after1_rental {
    type: time
    timeframes: [raw, date]
    hidden: yes
    sql: ${TABLE}.next_rental_date_after1 ;;
  }

  dimension: rental_id_after2_rental {
    type: number
    hidden:  yes
    sql: ${TABLE}.next_rental_id_after2 ;;
  }

  dimension_group: rental_date_after2_rental {
    type: time
    timeframes: [raw, date]
    hidden: yes
    sql: ${TABLE}.next_rental_date_after2 ;;
  }

  dimension: has_repeat_rental_after1 {
    type: yesno
    sql: ${rental_id_after1_rental} > 0 ;;
  }

  dimension: has_repeat_rental_after2 {
    type: yesno
    sql: ${rental_id_after1_rental} > 0 ;;
  }

  dimension: customer_id{
    hidden: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  set: detail {
    fields: [rental_id]
  }

  }
