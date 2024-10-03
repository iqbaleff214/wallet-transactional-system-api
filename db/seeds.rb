# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# User.create(
#   name: 'M. Iqbal Effendi',
#   email: 'iqbaleff214@gmail.com',
#   password: 'password'
# )

# User.create(
#   name: 'Mahda Nurdiana',
#   email: 'mahdanurdiana@gmail.com',
#   password: 'password'
# )

# Team.create(
#   name: 'First Team'
# )

# Team.create(
#   name: 'Second Team'
# )

# Team.create(
#   name: 'Third Team'
# )

Stock.create(
  name: 'Stock A',
  quantity: 90,
  price: 90_000.to_f
)

Stock.create(
  name: 'Stock B',
  quantity: 10,
  price: 900_000.to_f
)

Stock.create(
  name: 'Stock C',
  quantity: 5,
  price: 1000_000.to_f
)
