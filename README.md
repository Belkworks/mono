
# Mono
*A text table builder.*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
TextTable = NEON:github('belkworks', 'Mono')
```

## Example
```lua
data = {
    {'header 1', 'header 2'},
    {'data', 123},
    {'something else', 456}
}

for i, line in pairs(TextTable(data))do
    print(line)
end
```

This outputs the following:
```
header 1       header 2
data           123     
something else 456     
```
