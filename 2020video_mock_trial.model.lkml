connection: "video_store"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

##### Configuration #####
datagroup: inventory_dg {
  sql_trigger: SELECT MAX(last_update) FROM  inventory;;
  max_cache_age: "1 hours"
  label: "New inventory data fetched"
  description: "Data group to pick latest inventory"
}

persist_with: inventory_dg

datagroup: customer360_dg {
  sql_trigger: SELECT MAX(customer_id) FROM  customer;;
  max_cache_age: "1 hours"
  label: "Fetch new customers"
  description: "Data group to pick new customers"
}

persist_with: customer360_dg


explore: rental {
  join: inventory {
    relationship: many_to_one
    sql_on: ${rental.inventory_id} = ${inventory.inventory_id} ;;
    type: left_outer
  }

  join: payment {
    relationship: one_to_one
    sql_on: ${rental.rental_id} = ${payment.rental_id} ;;
    type: inner
  }

  join: film{
    relationship: many_to_one
    sql_on: ${inventory.film_id}=${film.film_id} ;;
    type: left_outer
  }

  join: rental_inventory {
    relationship: many_to_one
    sql_on: ${inventory.film_id}=${rental_inventory.film_id} ;;
    type: inner
  }

  join: film_category {
    relationship: many_to_one
    sql_on: ${inventory.film_id}=${film_category.film_id} ;;
    type: left_outer
  }

  join: customer_360 {
    relationship: many_to_one
    sql_on: ${rental.customer_id}=${customer_360.customer_id} ;;
    type: left_outer
  }

  join: customer {
    relationship: many_to_one
    sql_on: ${customer.customer_id} = ${rental.customer_id} ;;
    type: left_outer
  }

  join: address {
    relationship: one_to_one
    sql_on: ${customer.address_id}=${address.address_id} ;;
    type: inner
  }

  join: city {
    relationship: many_to_one
    sql_on: ${address.city_id}= ${city.city_id} ;;
    type: left_outer
  }

  join: country {
    relationship: many_to_one
    sql_on: ${city.country_id}=${country.country_id} ;;
    type: left_outer
  }

  join: category {
    relationship: many_to_one
    sql_on: ${film_category.category_id}=${category.category_id} ;;
    type: left_outer
  }
}
