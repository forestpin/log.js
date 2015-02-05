LOG = (require './log').log

LOG 'debug', 'connector_startup', 'Connector starting', {user: 'varuna'}
LOG 'info', 'connector_startup', 'Connector starting'
LOG 'warn', 'connector_startup', 'Connector starting', {user: 'varuna'}, {stack: false}
LOG 'error', 'connector_startup', 'Connector starting', {user: 'varuna'}, {stack: false}
LOG 'stat', 'connector_startup', 'Connector starting', {}, {stack: false}
LOG 'info', 'connector_startup', 'Connector starting', {user: {email: "vpj@test.com", age: 27}}, {stack: true}

