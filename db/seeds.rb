# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
  { key: 'D dorian', pitches: %w[D4 F4 E4 D4 G4 F4 A4 G4 F4 E4 D4] },
  { key: 'E phrygian', pitches: %w[E4 C4 D4 C4 A3 A4 G4 E4 F4 E4] },
  { key: 'F lydian', pitches: %w[F4 G4 A4 F4 D4 E4 F4 C5 A4 F4 G4 F4] },
].each do |fux_cantus_firmus|
  composition = Composition.where(name: "Fux Example in #{fux_cantus_firmus[:key]}", key: fux_cantus_firmus[:key]).first_or_create
  voice = Voice.where(composition_id: composition.id, cantus_firmus: true).first_or_create
  fux_cantus_firmus[:pitches].each_with_index do |pitch, i|
    voice.notes << Note.new(bar: i + 1, pitch: pitch)
  end
end
