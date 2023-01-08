class CarPark
  attr_accessor :small_space, :medium_space, :large_space, :car_parked

  def initialize(small_space:, medium_space:, large_space:)
    @small_space = small_space
    @medium_space = medium_space
    @large_space = large_space
    @car_parked = { 'small_space' => {}, 'medium_space' => {}, 'large_space' => {} }
  end

  def admit_the_car(license_plat_number, car_size)
    return false unless any_space_available?

    move_the_car('medium_space') if @small_space.positive? && !(@medium_space.positive? || car_size == 'small')
    parkable = false
    parkable_space = ''

    if car_size == 'small' && any_space_available?
      parkable = true

      if @small_space.positive?
        parkable_space = 'small_space'
      elsif @medium_space.positive?
        parkable_space = 'medium_space'
      elsif @large_space.positive?
        parkable_space = 'large_space'
      end
    elsif car_size == 'medium' && (large_or_medium_space_available? || move_the_car('medium_space'))
      parkable = true

      if @medium_space.positive?
        parkable_space = 'medium_space'
      elsif @large_space.positive?
        parkable_space = 'large_space'
      end
    elsif car_size == 'large' && (@large_space.positive? || move_the_car('large_space'))
      parkable = true
      parkable_space = 'large_space'
    end

    if parkable && parkable_space != ''
      @car_parked[parkable_space][license_plat_number] = car_size

      case parkable_space
      when 'small_space'
        @small_space -= 1
      when 'medium_space'
        @medium_space -= 1
      when 'large_space'
        @large_space -= 1
      end
    end

    parkable
  end

  def exit_the_car(license_plat_number)
    exited_the_car = false
    @car_parked.each do |parking_space_type, parked_cars|
      next if parked_cars[license_plat_number].nil?

      parked_cars.delete(license_plat_number)
      exited_the_car = true

      case parking_space_type
      when 'small_space'
        @small_space += 1
      when 'medium_space'
        @medium_space += 1
      when 'large_space'
        @large_space += 1
      end
    end

    exited_the_car
  end

  private

  def move_the_car(move_from)
    movable = false
    car_sizes = ['small']
    car_sizes.push('medium') if move_from == 'large_space'

    car_sizes.each do |car_size|
      car = @car_parked[move_from].select { |_license_plat_number, size| size == car_size }

      if car_size == 'small' && !car.keys.empty? && any_space_available?
        movable = true
      elsif car_size == 'medium' && !car.keys.empty? && large_or_medium_space_available?
        movable = true
      end

      plat_number = car.keys.first

      if movable && !plat_number.nil?
        exit_the_car(plat_number)
        admit_the_car(plat_number, car_size)
      end
    end

    movable
  end

  def any_space_available?
    @small_space.positive? || large_or_medium_space_available?
  end

  def large_or_medium_space_available?
    @medium_space.positive? || @large_space.positive?
  end
end

# Example 1
# car = CarPark.new(medium_space: 1, small_space: 1, large_space: 1)
# p car.admit_the_car('license_plat_number1', 'small')
# p car.admit_the_car('license_plat_number2', 'small')
# p car.admit_the_car('license_plat_number3', 'small')
# p car.exit_the_car('license_plat_number1')
# p car.admit_the_car('license_plat_number4', 'large')
# p car.exit_the_car('license_plat_number2')
# p car.admit_the_car('license_plat_number5', 'medium')
# p car.car_parked

# Output
# {
#   'small_space'=>{'license_plat_number3'=>'small'},
#   'medium_space'=>{'license_plat_number5'=>'medium'},
#   'large_space'=>{'license_plat_number4'=>'large'}
# }

# Example 2
car = CarPark.new(small_space: 1, medium_space: 2, large_space: 1)
p car.admit_the_car('license_plat_number1', 'small')
p car.admit_the_car('license_plat_number2', 'small')
p car.admit_the_car('license_plat_number3', 'small')
p car.admit_the_car('license_plat_number4', 'medium')
p car.exit_the_car('license_plat_number1')
p car.admit_the_car('license_plat_number5', 'large')
p car.exit_the_car('license_plat_number2')
p car.admit_the_car('license_plat_number6', 'medium')
p car.car_parked

# Output
# {
#   'small_space'=>{'license_plat_number3'=>'small'},
#   'medium_space'=>{'license_plat_number4'=>'medium',
#   'license_plat_number6'=>'medium'},
#   'large_space'=>{'license_plat_number5'=>'large'}
# }
