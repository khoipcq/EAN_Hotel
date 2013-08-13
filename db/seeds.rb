# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
## =======DEFAULT DATA: To add default data to heroku, run these:
#  heroku run rake db:migrate RAILS_ENV=production
#  heroku run rake csv_model_import["db/data/Country_120924.txt",Country,true] RAILS_ENV=production
#  heroku run rake csv_model_import["db/data/State_120924.txt",State,true] RAILS_ENV=production
#  heroku run rake csv_model_import["db/data/Airport_120924.txt",Airport,true] RAILS_ENV=production
#  heroku run rake db:seed RAILS_ENV=production
## =======END DEFAULT DATA

# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Image_Data/HotelImageList.zip,HotelImageList,true,HotelImageList.txt]
#=> 2774026
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Amenity_Policy_Data/AttributeList.zip,AttributeList,true,AttributeList.txt]
#=> 476
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Amenity_Policy_Data/GDSAttributeList.zip,GDSAttributeList,true,GDSAttributeList.txt]
#=> 73
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Amenity_Policy_Data/GDSPropertyAttributeLink.zip,GDSPropertyAttributeLink,true,GDSPropertyAttributeLink.txt]
#=> 448065
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Amenity_Policy_Data/PropertyAttributeLink.zip,PropertyAttributeLink,true,PropertyAttributeLink.txt]
#=> 6205362
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Hotel_Details/Hotel_Description.zip,HotelDescription,true,"Hotel_Description 01-07-13.txt"]
#=> 106374
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Hotel_Details/Property_Amenity_En.zip,PropertyAmenity,true,"Property_Amenity_En 01-07-13.txt"]
#=> 2540716

# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Property_Data/AreaAttractionsList.zip,AreaAttractionList,true,AreaAttractionsList.txt]
#=> 142701
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Property_Data/ChainList.zip,ChainList,true,ChainList.txt]
#=> 694
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Property_Data/DiningDescriptionList.zip,DiningDescriptionList,true,DiningDescriptionLIst.txt]
#=> 133593
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Property_Data/PolicyDescriptionList.zip,PolicyDescriptionList,true,PolicyDescriptionList.txt]
#=> 119184
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Property_Data/PropertyDescriptionList.zip,PropertyDescriptionList,true,PropertyDescriptionList.txt]
#=> 156524
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Property_Data/PropertyTypeList.zip,PropertyTypeList,true,PropertyTypeList.txt]
#=> 41
#rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Property_Data/RecreationDescriptionList.zip,RecreationDescriptionList,true,RecreationDescriptionList.txt]
#=> 104535
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Property_Data/SpaDescriptionList.zip,SpaDescriptionList,true,SpaDescriptionList.txt]
#=> 10025
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Property_Data/WhatToExpectList.zip,WhatToExpectList,true,WhatToExpectList.txt]
#=> 2
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Room_Type_Data/RoomTypeList.zip,RoomTypeList,true,RoomTypeList.txt]
#=> 403715

# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Special_Content_Files/Star_Rating_Value.zip,StarRating,true,"Star_Rating_Value 01-07-13.txt"]
#=> 158489
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Special_Content_Files/Landmark.zip,LandmarkDestination,true,Landmark.txt]
#=> 98873
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Special_Content_Files/PropertyRoomTypes.zip,PropertyRoomType,true,"PropertyRoomTypes 01-07-13.txt"]
#=> 448707
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Special_Content_Files/Destination_Detail.zip,DestinationID,true,"Destination_Detail 01-07-13.txt"]
#=> 46615
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Special_Content_Files/Currency.csv,Currency,true]
#=> 207
# rake csv_model_import[/media/longphan-hoang/DATA/git_projects/EAN/materials/Special_Content_Files/Property_Theme_Data.csv,PropertyThemeData,true]
#=> 188159
# States
#=> 83
# Airports
#=> 1926

## Create admin user
 p "================================================="
 p "BEGIN: create admin user with these information:"
 user = User.new
 user.first_name = "Louis"
 user.last_name = "Collins"
 user.email = "admin@wayfarer.co"
 user.password = "admin_wayfarer_co"
 user.confirmed_at = Time.now
 user.save
 p "FINISH: create admin user with these information:"
 p user
 # add admin role
 user.roles.create(:title => "admin")
 user.save
 p "================================================="
