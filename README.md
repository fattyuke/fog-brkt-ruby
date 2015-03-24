# Fog::Brkt

Module for the 'fog' gem to support Bracket

## Installation

Add this line to your application's Gemfile:

    gem 'fog-brkt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fog-brkt

## Usage

First of all you need to create a compute object:

    2.2.0 > compute = Fog::Compute.new({
        :provider => "brkt",
        :brkt_public_access_token => "token here",
        :brkt_private_mac_key => "mac key here",
        :brkt_api_host: "api.host" # optional
    })

Let's check existance of computing cells & billing groups:

    2.2.0 > compute.computing_cells
    =>   <Fog::Compute::Brkt::ComputingCells
    [
                  <Fog::Compute::Brkt::ComputingCell
        id="78830636ebcb4151b2d3d638258fd785",
        name="us-west-2",
        description="",
        provider="AWS",
        gateway_ip="10.0.249.4",
        provider_options={"default_aws_avail_zone"=>"us-west-2b", "state"=>"READY", "aws_region"=>"us-west-2", "why"=>""}
      >
    ]

    2.2.0 > compute.billing_groups
    =>   <Fog::Compute::Brkt::BillingGroups
      [
                <Fog::Compute::Brkt::BillingGroup
          id="147bfba168444dbcad2b79e88ae9afc9",
          name="default",
          description="",
          members=["/v1/api/config/billinggroup/147bfba168444dbcad2b79e88ae9afc9/members"],
          customer="ffffffffffff4fffafffffffffffff00"
        >
      ]
     >
    2.2.0 > default_billing_group = compute.billing_groups.get("147bfba168444dbcad2b79e88ae9afc9")
     =>    <Fog::Compute::Brkt::BillingGroup
        id="147bfba168444dbcad2b79e88ae9afc9",
        name="default",
        description="",
        members=["/v1/api/config/billinggroup/147bfba168444dbcad2b79e88ae9afc9/members"],
        customer="ffffffffffff4fffafffffffffffff00"
      >


Creating workload template:

    2.2.0 > compute.workload_templates.create()
    ArgumentError: name, assigned_groups and assigned_zones are required for this operation

    2.2.0 > workload_template = compute.workload_templates.create({
        :name => "test workload template",
        :description => "workload template for test purposes",
        :assigned_groups => [default_billing_group.id],
        :assigned_zones => [compute.computing_cells.first.zones.first.id]
    })
     =>   <Fog::Compute::Brkt::WorkloadTemplate
        id="902c983665ea451bbf193c38d38f95ce",
        name="test workload template",
        description="workload template for test purposes",
        assigned_groups=["147bfba168444dbcad2b79e88ae9afc9"],
        assigned_zones=["df43995a1d8a48d28b835238bfd079b4"],
        fixed_charge=0.0,
        base_hourly_rate=0.0,
        hourly_cost=0.0,
        daily_cost=0.0,
        monthly_cost=0.0,
        max_cost=0.0,
        enable_service_domain=false,
        state="PUBLISHED",
        metadata={}
      >

Check whether worload template contains any server templates:

    2.2.0 > workload_template.server_templates
     =>   <Fog::Compute::Brkt::ServerTemplates
        [

        ]
      >

Let's create one:

    2.2.0 > workload_template.server_templates.create()
    ArgumentError: name and image_definition are required for this operation

Image definition is required to create an instance template. To list available image definitions:

    2.2.0 :034 > compute.images
     =>   <Fog::Compute::Brkt::Images
        [
                      <Fog::Compute::Brkt::Image
            id="f789efac46bf43c792e51b73d28fc398",
            name="Ubuntu 13.10 Saucy (64 bit)",
            description="",
            state="READY",
            is_base=true,
            is_encrypted=false,
            os={"customer"=>nil, "modified_by"=>nil, "description"=>"", "os_features"=>{}, "modified_time"=>"2015-02-23T22:03:46.944208+00:00", "label"=>"Ubuntu 13.10 Saucy (64 bit)", "platform"=>"linux", "version"=>"13.10", "created_by"=>nil, "created_time"=>"2015-02-23T22:03:46.944180+00:00", "metadata"=>{}, "id"=>"bd2c801afb174ca9baba61363a2a5554", "name"=>"ubuntu"},
            os_settings={"mounts.options"=>"nobootwait"}
          >,
                      <Fog::Compute::Brkt::Image
            id="ea83044d366646c493717ac11b67b766",
            name="Red Hat Enterprise Linux 6.4 (64 bit)",
            description="",
            state="READY",
            is_base=true,
            is_encrypted=false,
            os={"customer"=>nil, "modified_by"=>nil, "description"=>"", "os_features"=>{}, "modified_time"=>"2015-02-23T22:03:46.949930+00:00", "label"=>"Red Hat Enterprise Linux 6.4 (64 bit)", "platform"=>"linux", "version"=>"6.4", "created_by"=>nil, "created_time"=>"2015-02-23T22:03:46.949899+00:00", "metadata"=>{}, "id"=>"bcd4bbc6368c47cf95fc95e791d1e066", "name"=>"rhel"},
            os_settings={"mounts.options"=>"nofail"}
          ...
    2.2.0 > image = compute.images.first
     =>   <Fog::Compute::Brkt::Image
        id="f789efac46bf43c792e51b73d28fc398",
        name="Ubuntu 13.10 Saucy (64 bit)",
        description="",
        state="READY",
        is_base=true,
        is_encrypted=false,
        os={"customer"=>nil, "modified_by"=>nil, "description"=>"", "os_features"=>{}, "modified_time"=>"2015-02-23T22:03:46.944208+00:00", "label"=>"Ubuntu 13.10 Saucy (64 bit)", "platform"=>"linux", "version"=>"13.10", "created_by"=>nil, "created_time"=>"2015-02-23T22:03:46.944180+00:00", "metadata"=>{}, "id"=>"bd2c801afb174ca9baba61363a2a5554", "name"=>"ubuntu"},
        os_settings={"mounts.options"=>"nobootwait"}

    2.2.0 > workload_template.server_templates.create({
        :name => "test server",
        :description => "server for test purposes",
        :image_definition => image.id
    })


Check server templates list again:

    2.2.0 > workload_template.server_templates
     =>   <Fog::Compute::Brkt::ServerTemplates
        [
                      <Fog::Compute::Brkt::ServerTemplate
            id="ffe1198f18ae446b89c03378e437009a",
            name="test server",
            description="server for test purposes",
            service_name="",
            workload_template="902c983665ea451bbf193c38d38f95ce",
            image_definition={"customer"=>nil, "os_settings"=>{"mounts.options"=>"nobootwait"}, "modified_by"=>nil, "description"=>"", "unencrypted_parent"=>nil, "csp_images"=>"/v1/api/config/imagedefinition/f789efac46bf43c792e51b73d28fc398/cspimages", "created_by"=>nil, "is_encrypted"=>false, "metadata"=>{}, "state"=>"READY", "modified_time"=>"2015-02-23T22:03:47.036014+00:00", "created_time"=>"2015-02-23T22:03:47.035985+00:00", "is_base"=>true, "os"=>{"customer"=>nil, "modified_by"=>nil, "description"=>"", "os_features"=>{}, "modified_time"=>"2015-02-23T22:03:46.944208+00:00", "label"=>"Ubuntu 13.10 Saucy (64 bit)", "platform"=>"linux", "version"=>"13.10", "created_by"=>nil, "created_time"=>"2015-02-23T22:03:46.944180+00:00", "metadata"=>{}, "id"=>"bd2c801afb174ca9baba61363a2a5554", "name"=>"ubuntu"}, "id"=>"f789efac46bf43c792e51b73d28fc398", "name"=>"Ubuntu 13.10 Saucy (64 bit)"},
            machine_type=nil,
            assigned_groups=["147bfba168444dbcad2b79e88ae9afc9"],
            security_groups=[],
            load_balancer_template=nil,
            requires_ssd=false,
            requires_encryption=false,
            min_quantity=1,
            cpu_arch="amd64",
            cpu_cores_minimum=1,
            ram_minimum=2,
            requires_gpu=false,
            fixed_charge=0.0,
            base_hourly_rate=0.1225,
            hourly_cost=0.13,
            daily_cost=2.94,
            monthly_cost=88.2,
            cloudinit_id="a132f53b7d07491ebfd619e15bb575e2",
            cloudinit_script="",
            cloudinit_type="DEFAULT",
            internet_accessible=false,
            state="PUBLISHED",
            metadata={}
          >
        ]
      >

Deploy workload template:

    2.2.0 > workload = workload_template.deploy(default_billing_group)
     =>   <Fog::Compute::Brkt::Workload
        id="e3ceb8eb0ea7424aa76b530b3332e65d",
        name="test workload template",
        description="workload template for test purposes",
        billing_group="147bfba168444dbcad2b79e88ae9afc9",
        zone="df43995a1d8a48d28b835238bfd079b4",
        fixed_charge=0.0,
        base_hourly_rate=0.1225,
        hourly_cost=0.13,
        daily_cost=2.94,
        monthly_cost=88.2,
        max_cost=0.0,
        state="IGNORE",
        service_domain=nil,
        expired=false,
        workload_template="902c983665ea451bbf193c38d38f95ce"
      >

Wait synchronously for workload to become ready:

    2.2.0 > workload.wait_for { ready? }
    => {:duration=>185.0}
    2.2.0 > workload.ready?
    => true
    2.2.0 > workload.servers
     =>   <Fog::Compute::Brkt::Servers
        [
                      <Fog::Compute::Brkt::Server
            id="f9d1f58e31544709bd2408c5fc02da3b",
            name="test server",
            description="server for test purposes",
            workload=        <Fog::Compute::Brkt::Workload
              id="e3ceb8eb0ea7424aa76b530b3332e65d",
              name="test workload template",
              description="workload template for test purposes",
              billing_group="147bfba168444dbcad2b79e88ae9afc9",
              zone="df43995a1d8a48d28b835238bfd079b4",
              fixed_charge=0.0,
              base_hourly_rate=0.1225,
              hourly_cost=0.13,
              daily_cost=2.94,
              monthly_cost=88.2,
              max_cost=0.0,
              state="READY",
              service_domain=nil,
              expired=false,
              workload_template="902c983665ea451bbf193c38d38f95ce"
            >,
            image_definition=        <Fog::Compute::Brkt::Image
              id="f789efac46bf43c792e51b73d28fc398",
              name="Ubuntu 13.10 Saucy (64 bit)",
              description="",
              state="READY",
              is_base=true,
              is_encrypted=false,
              os={"customer"=>nil, "modified_by"=>nil, "description"=>"", "os_features"=>{}, "modified_time"=>"2015-02-23T22:03:46.944208+00:00", "label"=>"Ubuntu 13.10 Saucy (64 bit)", "platform"=>"linux", "version"=>"13.10", "created_by"=>nil, "created_time"=>"2015-02-23T22:03:46.944180+00:00", "metadata"=>{}, "id"=>"bd2c801afb174ca9baba61363a2a5554", "name"=>"ubuntu"},
              os_settings={"mounts.options"=>"nobootwait"}
            >,
            machine_type=        <Fog::Compute::Brkt::MachineType
              id="59e0c9a0ca0f41dba86fb30ccb56ddfd",
              cpu_cores=1,
              ram=3.75,
              storage_gb=4,
              encrypted_storage_gb=1.8,
              hourly_cost=0.13,
              provider=1,
              supports_pv=true
            >,
            ram=3.75,
            cpu_cores=1,
            provider_instance={"state"=>"READY", "why"=>""},
            ip_address="10.0.37.241",
            internet_accessible=false,
            internet_ip_address=nil,
            load_balancer=nil,
            service_name=nil,
            service_name_fqdn=nil,
            metadata={}
          >
        ]
      >

Now let's add a new server to this workload:

  2.2.0 > workload.servers.create()
  ArgumentError: name, image_definition and machine_type are required for this operation

To see list of available machine types:

  2.2.0 > compute.machine_types
   =>   <Fog::Compute::Brkt::MachineTypes
      [
                    <Fog::Compute::Brkt::MachineType
          id="565f94793df94bbba3f45ae2745ee23a",
          cpu_cores=4,
          ram=15.0,
          storage_gb=80,
          encrypted_storage_gb=36.0,
          hourly_cost=0.49,
          provider=1,
          supports_pv=true
        >,
                    <Fog::Compute::Brkt::MachineType
          id="721a109fd3e547cd8790bfd41e977712",
          cpu_cores=8,
          ram=30.0,
          storage_gb=160,
          encrypted_storage_gb=72.0,
          hourly_cost=0.98,
          provider=1,
          supports_pv=true
        >,
        ... skipped ...

Now try to create a server:

    2.2.0 > server = workload.servers.create({
      :name => "instance created not from template",
      :image_definition => image,
      :machine_type => compute.machine_types.first.id
    })
     =>   <Fog::Compute::Brkt::Server
        id="e690f0ac37a249ebac732097b03aa1f4",
        name="instance created not from template",
        description="",
        workload=    <Fog::Compute::Brkt::Workload
          id="57fd3a603c164ce3b9530a1b96e2e21a",
          name="test workload template",
          description="workload template for test purposes",
          billing_group="147bfba168444dbcad2b79e88ae9afc9",
          zone="df43995a1d8a48d28b835238bfd079b4",
          fixed_charge=0.0,
          base_hourly_rate=0.6125,
          hourly_cost=0.62,
          daily_cost=14.7,
          monthly_cost=441.0,
          max_cost=0.0,
          state="BOOTING",
          service_domain=nil,
          expired=false,
          workload_template="bfd5c3a8933b40369bf05a4752fee251"
        >,
        image_definition=    <Fog::Compute::Brkt::Image
          id="f789efac46bf43c792e51b73d28fc398",
          name="Ubuntu 13.10 Saucy (64 bit)",
          description="",
          state="READY",
          is_base=true,
          is_encrypted=false,
          os={"customer"=>nil, "modified_by"=>nil, "description"=>"", "os_features"=>{}, "modified_time"=>"2015-02-23T22:03:46.944208+00:00", "label"=>"Ubuntu 13.10 Saucy (64 bit)", "platform"=>"linux", "version"=>"13.10", "created_by"=>nil, "created_time"=>"2015-02-23T22:03:46.944180+00:00", "metadata"=>{}, "id"=>"bd2c801afb174ca9baba61363a2a5554", "name"=>"ubuntu"},
          os_settings={"mounts.options"=>"nobootwait"}
        >,
        machine_type=    <Fog::Compute::Brkt::MachineType
          id="565f94793df94bbba3f45ae2745ee23a",
          cpu_cores=4,
          ram=15.0,
          storage_gb=80,
          encrypted_storage_gb=36.0,
          hourly_cost=0.49,
          provider=1,
          supports_pv=true
        >,
        ram=15.0,
        cpu_cores=4,
        provider_instance={"state"=>"IGNORE", "why"=>""},
        ip_address=nil,
        internet_accessible=false,
        internet_ip_address=nil,
        load_balancer=nil,
        service_name=nil,
        service_name_fqdn=nil,
        metadata={}
      >

## Testing

To run test suite execute (it will mock interaction with API by default):

    $ rake spec

To run test suite against a real API endpoint execute:

    $ FOG_MOCK=false BRKT_API_HOST=<api host> BRKT_PUBLIC_ACCESS_TOKEN=<api public toke> BRKT_PRIVATE_MAC_KEY=<api private mac key> rake spec

In non-mocking mode some test take a long time to execute (for example you can test reboot instance behavior only after it's booted completely), to skip a slowest tests add FAST_TESTS=true

    $ FOG_MOCK=false FAST_TESTS=true BRKT_API_HOST=<api host> BRKT_PUBLIC_ACCESS_TOKEN=<api public toke> BRKT_PRIVATE_MAC_KEY=<api private mac key> rake spec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
