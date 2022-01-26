"""Deploy Mosip in Cloudlab"""

import geni.portal as portal
import geni.rspec.pg as pg

# Create a portal object,
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

CENTOS_ARN = "urn:publicid:IDN+emulab.net+image+emulab-ops:CENTOS7-64-STD"
interfaces = []

node = request.RawPC("console")
node.disk_image = CENTOS_ARN
node.ram = 16 * 1024
node.cores = 4
node.disk = 256
interfaces.append(node.addInterface('interface-0'))

node = request.XenVM("mzmaster")
node.disk_image = CENTOS_ARN
node.ram = 8 * 1024
node.cores = 4
node.disk = 64
interfaces.append(node.addInterface('interface-1'))

for i in range(9):
    node = request.XenVM("mzworker" + str(i))
    node.disk_image = CENTOS_ARN
    node.ram = 16 * 1024
    node.cores = 4
    node.disk = 64
    interfaces.append(node.addInterface('interface-' + str(i + 2)))

node = request.XenVM("dmzmaster")
node.disk_image = CENTOS_ARN
node.ram = 8 * 1024
node.cores = 4
node.disk = 64
interfaces.append(node.addInterface('interface-11'))

node = request.XenVM("dmzworker")
node.disk_image = CENTOS_ARN
node.ram = 16 * 1024
node.cores = 4
node.disk = 64
interfaces.append(node.addInterface('interface-12'))

link = request.Link('link-0')
link.Site('undefined')
for interface in interfaces:
    link.addInterface(interface)

pc.printRequestRSpec(request)
