Gem::Specification.new do |s|
  s.name        = 'xbean'
  s.version     = '0.0.2'
  s.date        = '2018-07-16'
  s.summary     = "Archiver for iOS."
  s.description = "An Arciver tool for iOS."
  s.authors     = ["jewelz"]
  s.email       = 'hujewelz@163.com'
  s.files       = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|bin)})
  end
  s.executables << 'xbean'
  s.homepage    =
    'https://github.com/hujewelz/bean.git'
  s.license       = 'MIT'
end