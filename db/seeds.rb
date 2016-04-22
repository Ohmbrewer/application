# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name:  'Example User',
             email: 'example@ohmbrewer.org',
             password:              'foobar',
             password_confirmation: 'foobar',
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@ohmbrewer.org"
  password = 'password'
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end


# Make a rhizome
Rhizome.create!(
  name: "Test rhizome",
  particle_device_attributes: {
    device_id: Faker::Lorem.characters(24),
    encrypted_access_token: "S3jF/ramSAL8dZ4zzASXeuBunWv6tLn9jzcU4ABEflfGQkrwbM44CpWMtyRhkED/"
    }
  )


# Make an equipment profile
ep = EquipmentProfile.create!(
  name: "Test EP")

eq1 = HeatingElement.create!(
  power_pin: 1,
  control_pin: 0,
  equipment_profile: ep
  )

eq2 = TemperatureSensor.create!(
  data_pin: 2,
  onewire_index: 10,
  equipment_profile: ep
  )

eq3 = Thermostat.create!(
  equipment_profile: ep,
  element: HeatingElement.create!(
    power_pin: 3,
    control_pin: 5,
    equipment_profile: ep
    ),
  sensor: TemperatureSensor.create!(
    data_pin: 4,
    onewire_index: 9,
    equipment_profile: ep
    )
  )
  

# Make a schedule and tasks
sched = Schedule.create!(
  name: "Test Sched 1"
  )

t1 = TurnOnTask.create!(
  status: :queued,
  equipment_id: eq1.id,
  schedule_id: sched.id,
  duration: 60,
  )

t2 = TurnOnTask.create!(
  status: :queued,
  equipment_id: eq2.id,
  schedule_id: sched.id,
  duration: 15,
  parent_id: t1.id,
  trigger: :on_started
  )

sched[:root_task_id] = t1.id
sched.save


# Make a Recipe
BeerRecipe.create!(
  name: "Test Recipe",
  schedule_id: sched.id,
  )
