# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'evan@co', password: 'password', name: 'Evan')
User.create(email: 'adam@co', password: 'password', name: 'Adam')
Trip.create(trip_name: 'Evan Trip', user_id: 1)
Trip.create(trip_name: 'Adam Trip', user_id: 2)
Post.create(post_title: 'Post!', post_content: 'what a great and marvelous post. would post again', trip_id: 1, address1: 'chicago, il', address2: 'st louis, mo')
Post.create(post_title: 'Post_2!', post_content: 'what a great and marvelous post. would post again', trip_id: 1, address1: 'chicago, il', address2: 'st louis, mo')
Post.create(post_title: 'Post_3!', post_content: 'what a great and marvelous post. would post again', trip_id: 1, address1: 'joplin, mo', address2: 'oklahoma city, ok')
Post.create(post_title: 'Post!', post_content: 'what a great and marvelous post. would post again', trip_id: 2, address1: 'chicago, il', address2: 'st louis, mo')
Post.create(post_title: 'Post_2!', post_content: 'what a great and marvelous post. would post again', trip_id: 2, address1: 'chicago, il', address2: 'st louis, mo')
Post.create(post_title: 'Post_3!', post_content: 'what a great and marvelous post. would post again', trip_id: 2, address1: 'joplin, mo', address2: 'oklahoma city, ok')
