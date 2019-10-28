composer.phar:
	curl -s https://getcomposer.org/installer | php
	php composer.phar install --prefer-dist -o --dev

tests/Functional/parameters.yml:
	cp tests/Functional/parameters.yml.dist tests/Functional/parameters.yml

test: tests/Functional/parameters.yml
	vendor/bin/phpunit -c tests/ tests/

test_phpunit_7: tests/Functional/parameters.yml
	vendor/bin/phpunit -c tests/phpunit7.xml tests/

phpstan: phpstan.phar
	./phpstan.phar analyse -c phpstan.neon -a vendor/autoload.php -l 7 src

phpstan.phar:
	wget https://raw.githubusercontent.com/phpstan/phpstan-shim/0.11.8/phpstan.phar && chmod 777 phpstan.phar

build: composer.phar test phpstan php_cs_fixer_check

php_cs_fixer_fix: php-cs-fixer.phar
	./php-cs-fixer.phar fix --config .php_cs src tests

php_cs_fixer_check: php-cs-fixer.phar
	./php-cs-fixer.phar fix --config .php_cs src tests --dry-run

php-cs-fixer.phar:
	wget https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.15.1/php-cs-fixer.phar && chmod 777 php-cs-fixer.phar
