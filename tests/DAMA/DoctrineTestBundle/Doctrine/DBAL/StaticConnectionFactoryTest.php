<?php

namespace Tests\DAMA\DoctrineTestBundle\Doctrine\DBAL;

use DAMA\DoctrineTestBundle\Doctrine\DBAL\StaticConnectionFactory;
use DAMA\DoctrineTestBundle\Doctrine\DBAL\StaticDriver;
use Doctrine\Bundle\DoctrineBundle\ConnectionFactory;
use PHPUnit\Framework\TestCase;

class StaticConnectionFactoryTest extends TestCase
{
    /**
     * @dataProvider createConnectionDataProvider
     */
    public function testCreateConnection(bool $keepStaticConnections, int $expectedNestingLevel): void
    {
        $factory = new StaticConnectionFactory(new ConnectionFactory([]));

        StaticDriver::setKeepStaticConnections($keepStaticConnections);

        $connection = $factory->createConnection([
            'driverClass' => MockDriver::class,
        ]);

        $this->assertInstanceOf(StaticDriver::class, $connection->getDriver());
        $this->assertSame($expectedNestingLevel, $connection->getTransactionNestingLevel());
    }

    public function createConnectionDataProvider(): array
    {
        return [
            [false, 0],
            [true, 1],
        ];
    }
}
