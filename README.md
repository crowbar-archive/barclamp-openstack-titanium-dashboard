Welcome to a Barclamp for the Crowbar Framework project
=======================================================
_Copyright 2011, Dell, Inc._

The code and documentation is distributed under the Apache 2 license (http://www.apache.org/licenses/LICENSE-2.0.html). Contributions back to the source are encouraged.

The Crowbar Framework (https://github.com/dellcloudedge/crowbar) was developed by the Dell CloudEdge Solutions Team (http://dell.com/openstack) as a OpenStack installer (http://OpenStack.org) but has evolved as a much broader function tool. 
A Barclamp is a module component that implements functionality for Crowbar.  Core barclamps operate the essential functions of the Crowbar deployment mechanics while other barclamps extend the system for specific applications.

* This functonality of this barclamp DOES NOT stand alone, the Crowbar Framework is required * 

About this Barclamp-keystone
-------------------------------------

Information for this barclamp is maintained on the Crowbar Framework Wiki: https://github.com/dellcloudedge/crowbar/wiki

This is based on OpenStack.org distribution

This barclamp is designed to be used in conjunction with the OpenStack High-Availability barclamps please review the https://github.com/crowbar/barclamp-openstack-titanium-loadbalancer for deployment information.

This barclamp should be applued to  3 controller nodes.

This barclamp is responsible for installing and configuring the Apache hosted website which provides a Django-based user interface to OpenStack services including Nova, Swift, Keystone, etc. 

This is the final barclamp to be installed and as such the prerequisite for the nova dashboard proposal to be applied are the following: HAProxy, Percona, RabbitMQ, Keystone, Glance, Cinder, Quantum and Nova. 

3 controller nodes must added to the multi-controller role. The proposal can be applied as usual, the deployment of the role is represented by a circular icon that goes to a spinning state in deploying state to a deployed state. Quick verification of the successful deployment can be viewed by browsing to each controller independently (Port 80) and through the loadbalanced public virtual IP.



Legals
-------------------------------------
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

