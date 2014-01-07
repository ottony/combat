
class Tank

  attr_reader :bullets, :x, :y, :instruction_set, :desc, :mutate
  attr_accessor :kills
  
  def initialize(
      window,
      color = Gosu::Color.new(255, 255, 255, 255),
      instructions = random_instructions,
      desc = 0,
      mutate = 0.75,
      fertility_rate = 0.006)

    @window = window
    @color = color
    @desc = desc
    @mutate = mutate
    @fertility = fertility_rate
    @instruction_set = instructions
    
    start_constants

  end

  def update
    wander
    @bullets.each {|bullet| bullet.update }
    @bullets.reject! {|bullet| bullet.age > 20 }
  end
  
  def fire
    @cooldown -= Gosu::milliseconds - @last
    @last = Gosu::milliseconds
    make_new_bullet if @cooldown <= 0
  end
  
  def draw
    @image.draw_rot(@x, @y, 0, @angle, 0.5, 0.5, @scale, @scale, @color)
    draw_bullets
  end

  def get_hit
  end
  
  def age_in_seconds
    age/1000
  end

  def wander
    #return :dead if age > 15
    self.send(@instructions.next) unless @instructions == []
    replication
  end
  
  def replication
    if rand < @fertility
      mutate = 1-((1-@mutate)*(0.95+rand/10))
      @window.tanks << Tank.new(@window, randomize_color(@color.dup), descent_with_modification, @desc + 1, mutate)
    end
  end

  def turn_right
    @angle += 22.5
    @angle = (@angle*2 % 720)/2
  end
  
  def turn_left
    @angle -= 22.5
    @angle = (@angle*2 % 720)/2
  end
  
  def move
    @x += Gosu::offset_x(@angle-90, 3*@scale)
    @y += Gosu::offset_y(@angle-90, 3*@scale)
    @x %= @window.width
    @y %= @window.height
  end
  
  def make_new_bullet
    #bullet = Bullet.new(@window, @x, @y, @angle)
    #@window.cells.each do |cell|
    #  if bullet.x
    @bullets << Bullet.new(@window, @x, @y, @angle, @scale)
    @cooldown = 500
  end
  
  def descent_with_modification
  
    instruction = @instruction_set.dup
    #[->{instruction << :move} => @variation[0],
    # ->{instruction << :fire} => @variation[1],
    # ->{instruction << :turn} => @variation[2],
    # ->{instruction.pop unless instruction.size == 1} => @variation[3]
    #].sample.call
    [->{instruction << :move},
     ->{instruction << :fire},
     ->{instruction << :turn_right},
     ->{instruction << :turn_left},
     ->{instruction.delete_at(rand(instruction.length))}
    ].sample.call if rand > @mutate
    
    possible_instructions = [:move, :fire, :turn_right, :turn_left]
    instruction[rand(instruction.length)] = possible_instructions.sample if rand > @mutate
    
    #rand > 0.5 ? (instruction << :move) : (instruction.pop if ((instruction.length > 1) and (rand > 0.6)))
    #rand > 0.5 ? (instruction << [:move, :turn, :fire].sample) : (instruction.pop if instruction.length > 1)
    instruction#.shuffle

  end

  def age
    Gosu::milliseconds - @birth_date
  end

  private

  def start_constants
    @image = Gosu::Image.new(@window, "media/tank.bmp", true).retro!

    @x, @y = rand(1500) % @window.width, rand(1500) % @window.height
    @angle = 22.5*rand(16)
    @moving = false
    @bullets = []
    @kills = 0
    @age = 0
    @life_expectancy = 15000
    @birth_date = Gosu::milliseconds
    @instructions = @instruction_set.empty? ? [] : @instruction_set.cycle
    @cooldown = 0
    @last = Gosu::milliseconds
    @scale = @window.scale

  end
  
  def draw_bullets
    @bullets.each {|bullet| bullet.draw}
  end
  
  def random_instructions
    ([:fire]*rand(5) + [:turn_right]*rand(20) + [:turn_left]*rand(2) + [:move]*rand(40)).shuffle!
  end

  def randomize_color(color)
      red = color.red - 5 + 10*rand
      green = color.green - 5 + 10*rand
      blue = color.blue - 5 + 10*rand
      Gosu::Color.new(255, red, green, blue)
  end
end
