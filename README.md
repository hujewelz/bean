# What is xbean
xbean 是一个 iOS 自动打包工具。

## Installation

 你可以使用 gem 来安装 xbean :

```shell
gem install 'xbean'
```


## Usage

打开终端，进入你的工程的根目录，执行以下命令:

```shell
$ xbean init
```
`xbean init` 命令会在当前目录生成 `Beanfile` : 

```ruby
bean :dev do |a|
  a.workspace = 'YourWorkspace'
  a.scheme = 'YourScheme'
end
```

在 `Beanfile` 中可以定义多个 bean, 你可以为不同的环境配置不同的 bean:

```ruby
bean :dev do |c|
  c.workspace = 'YourWorkspace'
  c.scheme = 'YourScheme'
  c.method = 'ad-hoc'
end

bean :release do |c|
  c.workspace = 'YourWorkspace'
  c.scheme = 'YourScheme-Release'
  c.method = 'app-store'
end
```

然后就可以在终端运行它:

```shell
$ xbean dev
```