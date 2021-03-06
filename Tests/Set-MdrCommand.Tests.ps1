. "$PSScriptRoot\Header.ps1"

Describe 'Set-MdrCommand Tests' {
    InModuleScope -ModuleName 'SQLMDR' {
        . "$PSScriptRoot\Mocks.ps1"

        Context "Command Usage" {
            It "Supports WhatIf" {

            }

            It "Supports Force" {

            }
        }

        It "Prevents using enable and disable at the same time" {
            { Set-MdrCommand -Name 'ServerCommand1' -Category 'Database' -Enable -Disable } | Should Throw
        }

        It "Errors when using an invalid category" {
            { Set-MdrCommand -Name 'ServerCommand1' -Category 'Module1' } | Should Throw "Cannot validate argument on parameter 'Category'"
        }

        It "Errors when using an invalid frequency" {
            { Set-MdrCommand -Name 'ServerCommand1' -Frequency 'MadeUpFrequency' } | Should Throw "Cannot validate argument on parameter 'Frequency'"
        }

        It "Errors when command isn't registered" {
            Reset-MockCommand

            { Set-MdrCommand -Name 'Get-ChildItem' -Category 'Server' } | Should Throw 'Command not registered'
        }

        Context "Updates category" {
            It "By module" {
                Reset-MockCommand

                $moduleName = 'Module1'
                $categoryName = 'Database'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                Assert-MockCalled -CommandName 'Get-PSFConfig' -Times 1
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName }
                $command.Category | Should -Not -Be $categoryName

                Set-MdrCommand -Module $moduleName -Category $categoryName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName }
                $command | Select-Object -ExpandProperty Category -Unique | Should -Be $categoryName
            }

            It "By name" {
                Reset-MockCommand

                $commandName = 'ServerCommand1'
                $categoryName = 'Database'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                Assert-MockCalled -CommandName 'Get-PSFConfig' -Times 1
                $command = $command.Value | Where-Object { $_.Name -eq $commandName }
                $command.Category | Should -Not -Be $categoryName

                Set-MdrCommand -Name $commandName -Category $categoryName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -eq $commandName }
                $command.Category | Should -Be $categoryName
            }

            It "By array of names" {
                Reset-MockCommand

                $commandName = @('ServerCommand1', 'ServerCommand2')
                $categoryName = 'Database'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                Assert-MockCalled -CommandName 'Get-PSFConfig' -Times 1
                $command = $command.Value | Where-Object { $_.Name -in $commandName }
                $command.Category | Should -Not -Be $categoryName

                Set-MdrCommand -Name $commandName -Category $categoryName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -in $commandName }
                $command | Select-Object -ExpandProperty Category -Unique | Should -Be $categoryName
            }

            It "By module and name" {
                Reset-MockCommand

                $moduleName = 'Module1'
                $commandName = 'ServerCommand1'
                $categoryName = 'Database'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                Assert-MockCalled -CommandName 'Get-PSFConfig' -Times 1
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName -and $_.Name -eq $commandName }
                $command.Category | Should -Not -Be $categoryName

                Set-MdrCommand -Module $moduleName -Name $commandName -Category $categoryName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -eq $commandName }
                $command.Category | Should -Be $categoryName
            }

            It "From pipeline" {

            }
        }

        Context "Updates frequency" {
            It "By module" {
                Reset-MockCommand

                $moduleName = 'Module1'
                $frequency = 'Monthly'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                Assert-MockCalled -CommandName 'Get-PSFConfig' -Times 1
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName }
                $command.Frequency | Should -Not -Be $frequency

                Set-MdrCommand -Module $moduleName -Frequency $frequency
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName }
                $command | Select-Object -ExpandProperty Frequency -Unique | Should -Be $frequency
            }

            It "By name" {
                Reset-MockCommand

                $commandName = 'ServerCommand1'
                $frequency = 'Hourly'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                Assert-MockCalled -CommandName 'Get-PSFConfig' -Times 1
                $command = $command.Value | Where-Object { $_.Name -eq $commandName }
                $command.Frequency | Should -Not -Be $frequency

                Set-MdrCommand -Name $commandName -Frequency $frequency
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -eq $commandName }
                $command.Frequency | Should -Be $frequency
            }

            It "By array of names" {
                Reset-MockCommand

                $commandName = @('ServerCommand1', 'ServerCommand2')
                $frequency = 'Monthly'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                Assert-MockCalled -CommandName 'Get-PSFConfig' -Times 1
                $command = $command.Value | Where-Object { $_.Name -in $commandName }
                $command.Frequency | Should -Not -Be $frequency

                Set-MdrCommand -Name $commandName -Frequency $frequency
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -in $commandName }
                $command | Select-Object -ExpandProperty Frequency -Unique | Should -Be $frequency
            }

            It "By module and name" {
                Reset-MockCommand

                $moduleName = 'Module1'
                $commandName = 'ServerCommand1'
                $frequency = 'Hourly'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                Assert-MockCalled -CommandName 'Get-PSFConfig' -Times 1
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName -and $_.Name -eq $commandName }
                $command.Frequency | Should -Not -Be $frequency

                Set-MdrCommand -Module $moduleName -Name $commandName -Frequency $frequency
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -eq $commandName }
                $command.Frequency | Should -Be $frequency
            }

            It "From pipeline" {

            }
        }

        Context "Enables" {
            It "By module" {
                $moduleName = 'Module2'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Not -Be $true

                Enable-MdrCommand -Module $moduleName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Be $true
            }

            It "By name" {
                Reset-MockCommand

                $commandName = 'DisabledCommand1'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -eq $commandName }
                $command.Enabled | Should -Be $false

                Enable-MdrCommand -Name $commandName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -eq $commandName }
                $command.Enabled | Should -Be $true
            }

            It "By array of names" {
                Reset-MockCommand

                $commandName = @('DisabledCommand1', 'DisabledCommand2')

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -in $commandName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Be $false

                Enable-MdrCommand -Name $commandName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -in $commandName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Be $true
            }

            It "By module and name" {
                Reset-MockCommand

                $moduleName = 'Module2'
                $commandName = 'DisabledCommand1'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName -and $_.Name -eq $commandName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Be $false

                Enable-MdrCommand -Module $moduleName -Name $commandName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName -and $_.Name -eq $commandName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Be $true
            }

            It "From pipeline" {

            }
        }

        Context "Disables" {
            It "By module" {
                $moduleName = 'DisableByModule'

                Disable-MdrCommand -Module $moduleName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                Assert-MockCalled -CommandName 'Get-PSFConfig' -Times 1

                $command = $command.Value | Where-Object { $_.Module -eq $moduleName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Be $false
            }

            It "By name" {
                Reset-MockCommand

                $commandName = 'ServerCommand1'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -eq $commandName }
                $command.Enabled | Should -Be $true

                Disable-MdrCommand -Name $commandName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -eq $commandName }
                $command.Enabled | Should -Be $false
            }

            It "By array of names" {
                Reset-MockCommand

                $commandName = @('ServerCommand1', 'ServerCommand2')

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -in $commandName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Be $true

                Disable-MdrCommand -Name $commandName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Name -in $commandName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Be $false
            }

            It "By module and name" {
                Reset-MockCommand

                $moduleName = 'Module1'
                $commandName = 'ServerCommand1'

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName -and $_.Name -eq $commandName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Be $true

                Disable-MdrCommand -Module $moduleName -Name $commandName
                Assert-MockCalled -CommandName 'Set-PSFConfig' -Times 1

                $command = Get-PSFConfig -FullName 'sqlmdr.commands'
                $command = $command.Value | Where-Object { $_.Module -eq $moduleName -and $_.Name -eq $commandName }
                $command | Select-Object -ExpandProperty Enabled -Unique | Should -Be $false
            }

            It "From pipeline" {

            }
        }
    }
}
