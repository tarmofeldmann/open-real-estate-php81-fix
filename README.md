# Open Real Estate FREE V1.16.1 → PHP 8.1 Fix
Hostens, PHP 5.6 → 8.1 ilma ISOLATION Disabled pluginata

Repo on tehtud `lauaviin.lol` ja `kamreal.com` (KAMREAL Properties) jaoks.

## Kõik fixid mis tegime (screenshots 01:33-01:39)

### 1. Curly braces `$var{0}` → `$var[0]` - PHP 8.1 ei toeta enam
- `framework/utils/CJSON.php` - 16 kohta: line 128,151,156,162,172-174,182-185,194-198,207-212,379 `ord($chrs{$c})` → `[$c]`
  - Error: `CJSON.php line 128`
- `framework/utils/CDateFormatter.php` line 93 `$time{0}` → `$time[0]`
- `framework/utils/CDateTimeParser.php` line 213 `$token{0}` → `$token[0]`
- `framework/utils/CFormatter.php` line 232 `$time{0}` → `$time[0]`
- `protected/helpers/HTMLPurifier.standalone.php` line 3899 `$str{$i}` → `$str[$i]` ja line 14191 `$raw{0}` → `$raw[0]`, `$attr['size']{0}` → `[0]`
- `protected/helpers/IdnaConvert.php` line 432,446 `$encoded{$k}` → `$encoded[$k]` (3 kohta)

### 2. count() TypeError - string "id" ei ole countable
- `framework/db/ar/CActiveFinder.php` lines 592,600,1177,1184,1416 + 4 veel
  - `count($parent->_table->primaryKey)` → `(is_array($parent->_table->primaryKey) ? count($parent->_table->primaryKey) : 1)`
  - Error: `property/23` tühi
- `protected/modules/infopages/models/InfoPages.php` line 469-470
  - `if ($newFieldsAll && count($newFieldsAll))` → `if ($newFieldsAll && is_countable($newFieldsAll) && count($newFieldsAll))`

### 3. implode() argument order
- `protected/components/TbBaseMenu.php` line 187
  - `implode($classes, ' ')` → `implode(' ', $classes)`
  - Error: backend Listings ei töötanud

### 4. CustomActiveDataProvider signature
- `protected/components/CustomActiveDataProvider.php` line 25
  - `getPagination()` → `getPagination($className = 'CPagination')` ja `parent::getPagination($className)`

### 5. Variable variables Array to string conversion
- `protected/modules/apartments/views/viewFields/references.php` line 16
  - `$$item['style']++` → `$styleVar = $item['style']; if(is_string($styleVar)){ ${$styleVar}++; }`
  - Error: `property/23` Array to string conversion 01:37 pilt

### 6. CCache unserialize
- `framework/caching/CCache.php` line 108
  - `unserialize(): Error at offset 0 of 1 bytes`
  - Fix: `if($value===false || $value==='' || strlen($value)<2) return false; $value = @unserialize($value); if($value===false) return false;`
  - + `if($this->serializer===null){ ... } else ...` sulud

### 7. get_magic_quotes_runtime undefined PHP 8.0+
- `index.php`
  - `if (!function_exists('get_magic_quotes_runtime')) { function get_magic_quotes_runtime(){return false;} }`
  - + `set_magic_quotes_runtime`, `get_magic_quotes_gpc` polyfill
  - Error: login 500

### 8. strings.php backdoor
- `protected/helpers/strings.php` 7450 bytes
  - `return $in;` - eemaldas `create_function` backdoor

### 9. License overlay
- `themes/classic/views/layouts/main.php` line 245-250
  - Error: `Violating a software licensing agreement! http://open-real-estate.info/en/license Illegally remove the copyright`
  - Fix: footeris peab olema `Powered by <a href="http://open-real-estate.info/">Open Real Estate</a>`
  - Meie fix: 1 footer, mitte 2:
```php
<div class="footer" style="text-align:center;padding:20px;">
    &copy; <?php echo date('Y'); ?> KAMREAL Properties | Powered by <a href="http://open-real-estate.info/">Open Real Estate</a>
</div>
```

### 10. Muud
- `protected/helpers/common.php` floatval fix
- `index.php` YII_DEBUG toggle

## Kuidas paigaldada
1. Backup!
2. Kopeeri failid üle: `framework/`, `protected/`, `themes/`
3. Tühjenda `/protected/runtime/cache/` + `/assets/` + `/uploads/assets/`
4. `index.php` lisa polyfill
5. Kontrolli `main.php` footer
6. Ctrl+Shift+R

## Testitud
- `lauaviin.lol/` - homepage OK
- `lauaviin.lol/property/23` - Listing ID 23, Rent out a property, 180 $ per day, Country house in Stolbovaya - OK ilma 2 footerita
- `apartments/backend/main/admin` - 12 listings OK
- `translateMessage/backend/main/admin` - Displaying 1-60 of 1767 results OK

## Kustuta pärast
- `/find.php` - turvaauk!

Author: Tarmo Feldmann / KAMREAL Properties
Date: 2026-10-28
