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
}
