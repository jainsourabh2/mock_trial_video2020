view: customer_360 {
  derived_table: {
    sql: SELECT customer.customer_id
                ,first_name
                ,last_name
                ,email
                ,MIN(rental_date) AS first_rental_date
                ,MAX(rental_date) AS last_rental_date
                ,COUNT(DISTINCT rental.rental_id) AS total_rentals
                ,SUM(amount) AS total_payments
          FROM customer
          LEFT JOIN rental ON customer.customer_id = rental.customer_id
          LEFT JOIN payment ON customer.customer_id = payment.customer_id
          GROUP BY customer.customer_id
                ,first_name
                ,last_name,email ;;

    datagroup_trigger: customer360_dg
    indexes: ["customer_id"]
  }

  dimension: customer_id{
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension_group: first_rental_date {
    type: time
    sql: ${TABLE}.first_rental_date ;;
  }

  dimension_group: last_rental_date {
    type: time
    sql: ${TABLE}.last_rental_date ;;
  }

  measure: total_rentals {
    type: sum
    sql: ${TABLE}.total_rentals ;;
  }

  dimension: total_payments {
    type: number
    sql: ${TABLE}.total_payments;;
  }

  dimension: payment_tier {
    type: tier
    tiers: [100,200,300,400,500,600,700,800,900,1000]
    sql: ${total_payments} ;;
  }

  dimension_group: rental_cohort {
    type: duration
    sql_start: ${first_rental_date_date} ;;
    sql_end: ${last_rental_date_date} ;;
  }
}
