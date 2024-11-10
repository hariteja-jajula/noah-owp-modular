module bminoahowp

! NGEN_ACTIVE is to be set when running in the Nextgen framework
! https://github.com/NOAA-OWP/ngen
#ifdef NGEN_ACTIVE
   use bmif_2_0_iso
#else
   use bmif_2_0
#endif

  use RunModule 
  use, intrinsic :: iso_c_binding, only: c_ptr, c_loc, c_f_pointer
  implicit none

  type, extends (bmi) :: bmi_noahowp
     private
     type (noahowp_type) :: model
   contains
     procedure :: get_component_name => noahowp_component_name
     procedure :: get_input_item_count => noahowp_input_item_count
     procedure :: get_output_item_count => noahowp_output_item_count
     procedure :: get_input_var_names => noahowp_input_var_names
     procedure :: get_output_var_names => noahowp_output_var_names
     procedure :: initialize => noahowp_initialize
     procedure :: finalize => noahowp_finalize
     procedure :: get_start_time => noahowp_start_time
     procedure :: get_end_time => noahowp_end_time
     procedure :: get_current_time => noahowp_current_time
     procedure :: get_time_step => noahowp_time_step
     procedure :: get_time_units => noahowp_time_units
     procedure :: update => noahowp_update
     procedure :: update_until => noahowp_update_until
     procedure :: get_var_grid => noahowp_var_grid
     procedure :: get_grid_type => noahowp_grid_type
     procedure :: get_grid_rank => noahowp_grid_rank
     procedure :: get_grid_shape => noahowp_grid_shape
     procedure :: get_grid_size => noahowp_grid_size
     procedure :: get_grid_spacing => noahowp_grid_spacing
     procedure :: get_grid_origin => noahowp_grid_origin
     procedure :: get_grid_x => noahowp_grid_x
     procedure :: get_grid_y => noahowp_grid_y
     procedure :: get_grid_z => noahowp_grid_z
     procedure :: get_grid_node_count => noahowp_grid_node_count
     procedure :: get_grid_edge_count => noahowp_grid_edge_count
     procedure :: get_grid_face_count => noahowp_grid_face_count
     procedure :: get_grid_edge_nodes => noahowp_grid_edge_nodes
     procedure :: get_grid_face_edges => noahowp_grid_face_edges
     procedure :: get_grid_face_nodes => noahowp_grid_face_nodes
     procedure :: get_grid_nodes_per_face => noahowp_grid_nodes_per_face
     procedure :: get_var_type => noahowp_var_type
     procedure :: get_var_units => noahowp_var_units
     procedure :: get_var_itemsize => noahowp_var_itemsize
     procedure :: get_var_nbytes => noahowp_var_nbytes
     procedure :: get_var_location => noahowp_var_location
     procedure :: get_value_int => noahowp_get_int
     procedure :: get_value_float => noahowp_get_float
     procedure :: get_value_double => noahowp_get_double
     generic :: get_value => &
          get_value_int, &
          get_value_float, &
          get_value_double
     procedure :: get_value_ptr_int => noahowp_get_ptr_int
     procedure :: get_value_ptr_float => noahowp_get_ptr_float
     procedure :: get_value_ptr_double => noahowp_get_ptr_double
     generic :: get_value_ptr => &
           get_value_ptr_int, &
           get_value_ptr_float, &
           get_value_ptr_double
     procedure :: get_value_at_indices_int => noahowp_get_at_indices_int
     procedure :: get_value_at_indices_float => noahowp_get_at_indices_float
     procedure :: get_value_at_indices_double => noahowp_get_at_indices_double
     generic :: get_value_at_indices => &
           get_value_at_indices_int, &
           get_value_at_indices_float, &
           get_value_at_indices_double
     procedure :: set_value_int => noahowp_set_int
     procedure :: set_value_float => noahowp_set_float
     procedure :: set_value_double => noahowp_set_double
     generic :: set_value => &
          set_value_int, &
          set_value_float, &
          set_value_double
     procedure :: set_value_at_indices_int => noahowp_set_at_indices_int
     procedure :: set_value_at_indices_float => noahowp_set_at_indices_float
     procedure :: set_value_at_indices_double => noahowp_set_at_indices_double
     generic :: set_value_at_indices => &
           set_value_at_indices_int, &
           set_value_at_indices_float, &
           set_value_at_indices_double
  end type bmi_noahowp
  
  private
  public :: bmi_noahowp

  character (len=BMI_MAX_COMPONENT_NAME), target :: &
       component_name = "Noah-OWP-Modular Surface Module"

  ! Exchange items
  integer, parameter :: input_item_count = 8
  integer, parameter :: output_item_count = 23
  character (len=BMI_MAX_VAR_NAME), target, &
       dimension(input_item_count) :: input_items
  character (len=BMI_MAX_VAR_NAME), target, &
       dimension(output_item_count) :: output_items 

contains

  ! Get the name of the model.
  function noahowp_component_name(this, name) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), pointer, intent(out) :: name
    integer :: bmi_status

    name => component_name
    bmi_status = BMI_SUCCESS
  end function noahowp_component_name

  ! Count the input variables.
  function noahowp_input_item_count(this, count) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(out) :: count
    integer :: bmi_status

    count = input_item_count
    bmi_status = BMI_SUCCESS
  end function noahowp_input_item_count

  ! Count the output variables.
  function noahowp_output_item_count(this, count) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(out) :: count
    integer :: bmi_status

    count = output_item_count
    bmi_status = BMI_SUCCESS
  end function noahowp_output_item_count

  ! List input variables.
  function noahowp_input_var_names(this, names) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (*), pointer, intent(out) :: names(:)
    integer :: bmi_status

    input_items(1) = 'SFCPRS'   ! surface pressure (Pa)
    input_items(2) = 'SFCTMP'   ! surface air temperature (K)
    input_items(3) = 'SOLDN'    ! incoming shortwave radiation (W/m2)
    input_items(4) = 'LWDN'     ! incoming longwave radiation (W/m2)
    input_items(5) = 'UU'       ! wind speed in eastward direction (m/s)
    input_items(6) = 'VV'       ! wind speed in northward direction (m/s)
    input_items(7) = 'Q2'       ! mixing ratio (kg/kg)
    input_items(8) = 'PRCPNONC' ! precipitation rate (mm/s)
    
    names => input_items
    bmi_status = BMI_SUCCESS
  end function noahowp_input_var_names

  ! List output variables.
  function noahowp_output_var_names(this, names) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (*), pointer, intent(out) :: names(:)
    integer :: bmi_status

    output_items(1) = 'QINSUR'     ! total liquid water input to surface rate (m/s)
    output_items(2) = 'ETRAN'      ! transpiration rate (mm)
    output_items(3) = 'QSEVA'      ! evaporation rate (mm/s)
    output_items(4) = 'EVAPOTRANS' ! evapotranspiration rate (m/s)
    output_items(5) = 'TG'         ! surface/ground temperature (K) (becomes snow surface temperature when snow is present)
    output_items(6) = 'SNEQV'      ! snow water equivalent (mm)
    output_items(7) = 'TGS'        ! ground temperature (K) (is equal to TG when no snow and equal to bottom snow element temperature when there is snow)
    output_items(8) = 'ACSNOM'     ! Accumulated meltwater from bottom snow layer (mm) (NWM 3.0 output variable)
    output_items(9) = 'SNOWT_AVG'  ! Average snow temperature (K) (by layer mass) (NWM 3.0 output variable)
    output_items(10) = 'ISNOW'     ! Number of snow layers (unitless) (NWM 3.0 output variable)
    output_items(11) = 'QRAIN'     ! Rainfall rate on the ground (mm/s) (NWM 3.0 output variable)
    output_items(12) = 'FSNO'      ! Snow-cover fraction on the ground (unitless fraction) (NWM 3.0 output variable)
    output_items(13) = 'SNOWH'     ! Snow depth (m) (NWM 3.0 output variable)
    output_items(14) = 'SNLIQ'     ! Snow layer liquid water (mm) (NWM 3.0 output variable)
    output_items(15) = 'QSNOW'     ! Snowfall rate on the ground (mm/s) (NWM 3.0 output variable)
    output_items(16) = 'ECAN'      ! evaporation of intercepted water (mm) (NWM 3.0 output variable)
    output_items(17) = 'GH'        ! Heat flux into the soil (W/m-2) (NWM 3.0 output variable)
    output_items(18) = 'TRAD'      ! Surface radiative temperature (K) (NWM 3.0 output variable)
    output_items(19) = 'FSA'       ! Total absorbed SW radiation (W/m-2) (NWM 3.0 output variable)
    output_items(20) = 'CMC'       ! Total canopy water (liquid + ice) (mm) (NWM 3.0 output variable)
    output_items(21) = 'LH'        ! Total latent heat to the atmosphere (W/m-2) (NWM 3.0 output variable)
    output_items(22) = 'FIRA'      ! Total net LW radiation to atmosphere (W/m-2) (NWM 3.0 output variable)
    output_items(23) = 'FSH'       ! Total sensible heat to the atmosphere (W/m-2) (NWM 3.0 output variable)

    names => output_items
    bmi_status = BMI_SUCCESS
  end function noahowp_output_var_names

  ! BMI initializer.
  function noahowp_initialize(this, config_file) result (bmi_status)
    class (bmi_noahowp), intent(out) :: this
    character (len=*), intent(in) :: config_file
    integer :: bmi_status
    real :: start_time, end_time, elapsed_time

    call cpu_time(start_time)

    if (len(trim(config_file)) > 0) then
       call initialize_from_file(this%model, config_file)
    else
       !call initialize_from_defaults(this%model)
    end if
    bmi_status = BMI_SUCCESS

    call cpu_time(end_time)
    elapsed_time = end_time - start_time
    print *, 'Time for noahowp_initialize:', elapsed_time, ' seconds'
  end function noahowp_initialize

  ! BMI finalizer.
  function noahowp_finalize(this) result (bmi_status)
    class (bmi_noahowp), intent(inout) :: this
    integer :: bmi_status
    real :: start_time, end_time, elapsed_time

    call cpu_time(start_time)

    call cleanup(this%model)
    bmi_status = BMI_SUCCESS

    call cpu_time(end_time)
    elapsed_time = end_time - start_time
    print *, 'Time for noahowp_finalize:', elapsed_time, ' seconds'
  end function noahowp_finalize

  
  ! Model start time.
  function noahowp_start_time(this, time) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    double precision, intent(out) :: time
    integer :: bmi_status

    time = 0.d0
    bmi_status = BMI_SUCCESS
  end function noahowp_start_time

  ! Model end time.
  function noahowp_end_time(this, time) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    double precision, intent(out) :: time
    integer :: bmi_status

    time = dble(this%model%domain%ntime * this%model%domain%dt)
    bmi_status = BMI_SUCCESS
  end function noahowp_end_time

  ! Model current time.
  function noahowp_current_time(this, time) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    double precision, intent(out) :: time
    integer :: bmi_status

    time = dble(this%model%domain%time_dbl)
    bmi_status = BMI_SUCCESS
  end function noahowp_current_time

  ! Model time step.
  function noahowp_time_step(this, time_step) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    double precision, intent(out) :: time_step
    integer :: bmi_status

    time_step = dble(this%model%domain%dt)
    bmi_status = BMI_SUCCESS
  end function noahowp_time_step

  ! Model time units.
  function noahowp_time_units(this, units) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), intent(out) :: units
    integer :: bmi_status

    units = "s"
    bmi_status = BMI_SUCCESS
  end function noahowp_time_units

  ! Advance model by one time step.
  function noahowp_update(this) result (bmi_status)
    class (bmi_noahowp), intent(inout) :: this
    integer :: bmi_status
    real :: start_time, end_time, elapsed_time

    call cpu_time(start_time)

    call advance_in_time(this%model)
    bmi_status = BMI_SUCCESS

    call cpu_time(end_time)
    elapsed_time = end_time - start_time
    print *, 'Time for noahowp_update:', elapsed_time, ' seconds'
  end function noahowp_update

  ! Advance the model until the given time.
  function noahowp_update_until(this, time) result (bmi_status)
    class (bmi_noahowp), intent(inout) :: this
    double precision, intent(in) :: time
    integer :: bmi_status
    double precision :: n_steps_real
    integer :: n_steps, i, s
    real :: start_time, end_time, elapsed_time

    call cpu_time(start_time)

    if (time < this%model%domain%time_dbl) then
       bmi_status = BMI_FAILURE
       return
    end if

    n_steps_real = (time - this%model%domain%time_dbl) / this%model%domain%dt
    n_steps = floor(n_steps_real)
    do i = 1, n_steps
       s = this%update()
    end do
    ! call update_frac(this, n_steps_real - dble(n_steps)) ! NOT IMPLEMENTED
    bmi_status = BMI_SUCCESS

    call cpu_time(end_time)
    elapsed_time = end_time - start_time
    print *, 'Time for noahowp_update_until:', elapsed_time, ' seconds'
  end function noahowp_update_until
  
  ! Get the grid id for a particular variable.
  function noahowp_var_grid(this, name, grid) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), intent(in) :: name
    integer, intent(out) :: grid
    integer :: bmi_status

    select case(name)
    case('ACSNOM', 'AXAJ', 'BXAJ', 'CMC', 'CWP', 'ECAN', 'ETRAN',            &
         'EVAPOTRANS', 'FIRA', 'FRZX', 'FSA', 'FSH', 'FSNO', 'GH',           &
         'HVT', 'ISNOW', 'KDT', 'LH', 'LWDN', 'MFSNO', 'MP', 'PRCPNONC',     &
         'Q2', 'QINSUR', 'QRAIN', 'QSEVA', 'QSNOW', 'REFKDT', 'RSURF_EXP',   &
         'RSURF_SNOW', 'SCAMAX', 'SFCPRS', 'SFCTMP', 'SLOPE', 'SNEQV',       &
         'SNOWH', 'SNOWT_AVG', 'SOLDN', 'TG', 'TGS', 'TRAD', 'UU', 'VCMX25', &
         'VV', 'XXAJ')
         grid = 0
         bmi_status = BMI_SUCCESS
    case('SNLIQ')
         grid = 1
         bmi_status = BMI_SUCCESS
    case('BEXP','DKSAT','SMCMAX')
         grid = 2
         bmi_status = BMI_SUCCESS
    case default
       grid = -1
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_var_grid

  ! The type of a variable's grid.
  function noahowp_grid_type(this, grid, type) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    character (len=*), intent(out) :: type
    integer :: bmi_status

    select case(grid)
    case(0)
       type = "scalar"
       bmi_status = BMI_SUCCESS
    case(1,2)
       type = "vector"
       bmi_status = BMI_SUCCESS
!================================ IMPLEMENT WHEN noahowp DONE IN GRID ======================
!     case(1)
!       type = "uniform_rectilinear"
!        bmi_status = BMI_SUCCESS
    case default
       type = "-"
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_grid_type

  ! The number of dimensions of a grid.
  function noahowp_grid_rank(this, grid, rank) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    integer, intent(out) :: rank
    integer :: bmi_status

    select case(grid)
    case(0)
       rank = 0
       bmi_status = BMI_SUCCESS
    case(1,2)
       rank = 1
       bmi_status = BMI_SUCCESS
!================================ IMPLEMENT WHEN noahowp DONE IN GRID ======================
!     case(1)
!        rank = 2
!        bmi_status = BMI_SUCCESS
    case default
       rank = -1
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_grid_rank

  ! The dimensions of a grid.
  function noahowp_grid_shape(this, grid, shape) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    integer, dimension(:), intent(out) :: shape
    integer :: bmi_status

    select case(grid)
!================================ IMPLEMENT WHEN noahowp DONE IN GRID ======================
! NOTE: Scalar "grids" do not have dimensions, ie. there is no case(0)
!     case(1)
!        shape(:) = [this%model%n_y, this%model%n_x]
!        bmi_status = BMI_SUCCESS
    case (1)
       shape(:) = this%model%levels%nsnow
       bmi_status = BMI_SUCCESS
    case (2)
       shape(:) = this%model%levels%nsoil
       bmi_status = BMI_SUCCESS
    case default
       shape(:) = -1
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_grid_shape

  ! The total number of elements in a grid.
  function noahowp_grid_size(this, grid, size) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    integer, intent(out) :: size
    integer :: bmi_status

    select case(grid)
    case(0)
       size = 1
       bmi_status = BMI_SUCCESS
    case(1)
       size = this%model%levels%nsnow
       bmi_status = BMI_SUCCESS
!================================ IMPLEMENT WHEN noahowp DONE IN GRID ======================
!     case(1)
!        size = this%model%n_y * this%model%n_x
!        bmi_status = BMI_SUCCESS
    case(2)
      size = this%model%levels%nsoil
      bmi_status = BMI_SUCCESS
    case default
       size = -1
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_grid_size

  ! The distance between nodes of a grid.
  function noahowp_grid_spacing(this, grid, spacing) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    double precision, dimension(:), intent(out) :: spacing
    integer :: bmi_status

    select case(grid)
!================================ IMPLEMENT WHEN noahowp DONE IN GRID ======================
! NOTE: Scalar "grids" do not have spacing, ie. there is no case(0)
!     case(1)
!        spacing(:) = [this%model%dy, this%model%dx]
!        bmi_status = BMI_SUCCESS
    case default
       spacing(:) = -1.d0
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_grid_spacing
!
  ! Coordinates of grid origin.
  function noahowp_grid_origin(this, grid, origin) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    double precision, dimension(:), intent(out) :: origin
    integer :: bmi_status

    select case(grid)
!================================ IMPLEMENT WHEN noahowp DONE IN GRID ======================
! NOTE: Scalar "grids" do not have coordinates, ie. there is no case(0)
!     case(1)
!        origin(:) = [0.d0, 0.d0]
!        bmi_status = BMI_SUCCESS
    case default
       origin(:) = -1.d0
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_grid_origin

  ! X-coordinates of grid nodes.
  function noahowp_grid_x(this, grid, x) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    double precision, dimension(:), intent(out) :: x
    integer :: bmi_status

    select case(grid)
    case(0)
       x(:) = [0.d0]
       bmi_status = BMI_SUCCESS
    case default
       x(:) = -1.d0
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_grid_x

  ! Y-coordinates of grid nodes.
  function noahowp_grid_y(this, grid, y) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    double precision, dimension(:), intent(out) :: y
    integer :: bmi_status

    select case(grid)
    case(0)
       y(:) = [0.d0]
       bmi_status = BMI_SUCCESS
    case default
       y(:) = -1.d0
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_grid_y

  ! Z-coordinates of grid nodes.
  function noahowp_grid_z(this, grid, z) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    double precision, dimension(:), intent(out) :: z
    integer :: bmi_status

    select case(grid)
    case(0)
       z(:) = [0.d0]
       bmi_status = BMI_SUCCESS
    case default
       z(:) = -1.d0
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_grid_z

  ! Get the number of nodes in an unstructured grid.
  function noahowp_grid_node_count(this, grid, count) result(bmi_status)
    class(bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    integer, intent(out) :: count
    integer :: bmi_status

    select case(grid)
    case(0:2)
       bmi_status = this%get_grid_size(grid, count)
    case default
       count = -1
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_grid_node_count

  ! Get the number of edges in an unstructured grid.
  function noahowp_grid_edge_count(this, grid, count) result(bmi_status)
    class(bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    integer, intent(out) :: count
    integer :: bmi_status

    count = -1
    bmi_status = BMI_FAILURE
  end function noahowp_grid_edge_count

  ! Get the number of faces in an unstructured grid.
  function noahowp_grid_face_count(this, grid, count) result(bmi_status)
    class(bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    integer, intent(out) :: count
    integer :: bmi_status

    count = -1
    bmi_status = BMI_FAILURE
  end function noahowp_grid_face_count

  ! Get the edge-node connectivity.
  function noahowp_grid_edge_nodes(this, grid, edge_nodes) result(bmi_status)
    class(bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    integer, dimension(:), intent(out) :: edge_nodes
    integer :: bmi_status

    edge_nodes(:) = -1
    bmi_status = BMI_FAILURE
  end function noahowp_grid_edge_nodes

  ! Get the face-edge connectivity.
  function noahowp_grid_face_edges(this, grid, face_edges) result(bmi_status)
    class(bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    integer, dimension(:), intent(out) :: face_edges
    integer :: bmi_status

    face_edges(:) = -1
    bmi_status = BMI_FAILURE
  end function noahowp_grid_face_edges

  ! Get the face-node connectivity.
  function noahowp_grid_face_nodes(this, grid, face_nodes) result(bmi_status)
    class(bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    integer, dimension(:), intent(out) :: face_nodes
    integer :: bmi_status

    face_nodes(:) = -1
    bmi_status = BMI_FAILURE
  end function noahowp_grid_face_nodes

  ! Get the number of nodes for each face.
  function noahowp_grid_nodes_per_face(this, grid, nodes_per_face) result(bmi_status)
    class(bmi_noahowp), intent(in) :: this
    integer, intent(in) :: grid
    integer, dimension(:), intent(out) :: nodes_per_face
    integer :: bmi_status

    nodes_per_face(:) = -1
    bmi_status = BMI_FAILURE
  end function noahowp_grid_nodes_per_face

  ! The data type of the variable, as a string.
  function noahowp_var_type(this, name, type) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), intent(in) :: name
    character (len=*), intent(out) :: type
    integer :: bmi_status

    select case(name)
    case('ACSNOM', 'AXAJ', 'BEXP', 'BXAJ', 'CMC', 'CWP', 'DKSAT',          &
         'ECAN', 'ETRAN', 'EVAPOTRANS', 'FIRA', 'FRZX', 'FSA', 'FSH',      &
         'FSNO', 'GH', 'HVT', 'KDT', 'LH', 'LWDN', 'MFSNO', 'MP',          &
         'PRCPNONC', 'Q2', 'QINSUR', 'QRAIN', 'QSEVA', 'QSNOW', 'REFKDT',  &
         'RSURF_EXP', 'RSURF_SNOW', 'SCAMAX', 'SFCPRS', 'SFCTMP', 'SLOPE', &
         'SMCMAX', 'SNEQV', 'SNLIQ', 'SNOWH', 'SNOWT_AVG', 'SOLDN', 'TG',  &
         'TGS', 'TRAD', 'UU', 'VCMX25', 'VV', 'XXAJ')
       type = "real"
       bmi_status = BMI_SUCCESS
    case('ISNOW')
       type = "integer"
       bmi_status = BMI_SUCCESS
    case default
       type = "-"
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_var_type

  ! The units of the given variable.
  function noahowp_var_units(this, name, units) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), intent(in) :: name
    character (len=*), intent(out) :: units
    integer :: bmi_status

    select case(name)
    case("SFCPRS")
       units = "Pa"
       bmi_status = BMI_SUCCESS
    case("SFCTMP", "TG", "TGS","SNOWT_AVG","TRAD")
       units = "K"
       bmi_status = BMI_SUCCESS
    case("SOLDN", "LWDN", "GH", "FSA", "LH", "FIRA", "FSH")
       units = "W/m2"
       bmi_status = BMI_SUCCESS
    case("UU", "VV")
       units = "m/s"
       bmi_status = BMI_SUCCESS
    case("Q2")
       units = "kg/kg"
       bmi_status = BMI_SUCCESS
    case("QINSUR","DKSAT", "EVAPOTRANS")
       units = "m/s"
       bmi_status = BMI_SUCCESS
    case("PRCPNONC", "QRAIN", "QSEVA", "QSNOW")
       units = "mm/s"
       bmi_status = BMI_SUCCESS
    case("SNEQV", "ACSNOM", "SNLIQ", "ECAN", "ETRAN", "CMC")
       units = "mm"
       bmi_status = BMI_SUCCESS
    case("FSNO","ISNOW","MP","MFSNO","BEXP","KDT","RSURF_EXP","REFKDT","AXAJ","BXAJ","XXAJ","SLOPE","FRZX","SCAMAX")
       units = "unitless"
       bmi_status = BMI_SUCCESS
    case("SNOWH","HVT")
       units = "m"
       bmi_status = BMI_SUCCESS
    case("VCMX25")
       units = "umol co2/m**2/s"
       bmi_status = BMI_SUCCESS
    case("CWP")
       units = "1/m"
       bmi_status = BMI_SUCCESS
    case("RSURF_SNOW")
       units = 's/m'
       bmi_status = BMI_SUCCESS
    case("SMCMAX")
       units = 'volumetric'
       bmi_status = BMI_SUCCESS
    case default
       units = "-"
       bmi_status = BMI_FAILURE
    end select

  end function noahowp_var_units

  ! Memory use per array element.
  function noahowp_var_itemsize(this, name, size) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), intent(in) :: name
    integer, intent(out) :: size
    integer :: bmi_status

    associate(forcing    => this%model%forcing,   &
              water      => this%model%water,     &
              energy     => this%model%energy,    &
              parameters => this%model%parameters)

    select case(name)
    case("ACSNOM")
      size = sizeof(water%ACSNOM)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("AXAJ")
      size = sizeof(parameters%AXAJ)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("BEXP")
      size = sizeof(parameters%bexp(1))        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("BXAJ")
      size = sizeof(parameters%BXAJ)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("CMC")
      size = sizeof(water%CMC)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("CWP")
      size = sizeof(parameters%CWP)           ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("DKSAT")
      size = sizeof(parameters%dksat(1))        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("ECAN")
      size = sizeof(water%ECAN)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("ETRAN")
      size = sizeof(water%etran)                ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("EVAPOTRANS")
      size = sizeof(water%evapotrans)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("FIRA")
      size = sizeof(energy%FIRA)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("FRZX")
      size = sizeof(parameters%frzx)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("FSA")
      size = sizeof(energy%FSA)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("FSH")
      size = sizeof(energy%FSH)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("FSNO")
      size = sizeof(water%FSNO)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("GH")
      size = sizeof(energy%GH)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("HVT")
      size = sizeof(parameters%HVT)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("ISNOW")
      size = sizeof(water%ISNOW)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("KDT")
      size = sizeof(parameters%kdt)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("LH")
      size = sizeof(energy%LH)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("LWDN")
      size = sizeof(forcing%lwdn)                ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("MFSNO")
      size = sizeof(parameters%MFSNO)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("MP")
      size = sizeof(parameters%MP)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("PRCPNONC")
      size = sizeof(forcing%prcpnonc)                ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("Q2")
      size = sizeof(forcing%q2)                ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("QINSUR")
      size = sizeof(water%qinsur)                ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("QRAIN")
      size = sizeof(water%QRAIN)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("QSEVA")
      size = sizeof(water%qseva)                ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("QSNOW")
      size = sizeof(water%QSNOW)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("REFKDT")
      size = sizeof(parameters%refkdt)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("RSURF_EXP")
      size = sizeof(parameters%RSURF_EXP)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("RSURF_SNOW")
      size = sizeof(parameters%RSURF_SNOW)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("SCAMAX")
      size = sizeof(parameters%SCAMAX)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("SFCPRS")
      size = sizeof(forcing%sfcprs)  ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("SFCTMP")
      size = sizeof(forcing%sfctmp)             ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("SLOPE")
      size = sizeof(parameters%slope)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("SMCMAX")
      size = sizeof(parameters%smcmax(1))        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("SNEQV")
      size = sizeof(water%sneqv)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("SNLIQ")
      size = sizeof(water%SNLIQ(1))            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("SNOWH")
      size = sizeof(water%SNOWH)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("SNOWT_AVG")
      size = sizeof(energy%SNOWT_AVG)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("SOLDN")
      size = sizeof(forcing%soldn)                ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("TG")
      size = sizeof(energy%tg)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("TGS")
      size = sizeof(energy%tgs)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("TRAD")
      size = sizeof(energy%TRAD)            ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("UU")
      size = sizeof(forcing%uu)                ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("VCMX25")
      size = sizeof(parameters%VCMX25)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("VV")
      size = sizeof(forcing%vv)                ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case("XXAJ")
      size = sizeof(parameters%XXAJ)        ! 'sizeof' in gcc & ifort
      bmi_status = BMI_SUCCESS
    case default
       size = -1
       bmi_status = BMI_FAILURE
    end select
    end associate
  end function noahowp_var_itemsize

  ! The size of the given variable.
  function noahowp_var_nbytes(this, name, nbytes) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), intent(in) :: name
    integer, intent(out) :: nbytes
    integer :: bmi_status
    integer :: s1, s2, s3, grid, grid_size, item_size

    s1 = this%get_var_grid(name, grid)
    s2 = this%get_grid_size(grid, grid_size)
    s3 = this%get_var_itemsize(name, item_size)

    if (grid .eq. 0) then
       nbytes = item_size
       bmi_status = BMI_SUCCESS
    else if ((s1 == BMI_SUCCESS).and.(s2 == BMI_SUCCESS).and.(s3 == BMI_SUCCESS)) then
       nbytes = item_size * grid_size
       bmi_status = BMI_SUCCESS
    else
       nbytes = -1
       bmi_status = BMI_FAILURE
    end if
  end function noahowp_var_nbytes

  ! The location (node, face, edge) of the given variable.
  function noahowp_var_location(this, name, location) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), intent(in) :: name
    character (len=*), intent(out) :: location
    integer :: bmi_status
!==================== UPDATE IMPLEMENTATION IF NECESSARY WHEN RUN ON GRID =================
    select case(name)
    case default
       location = "node"
       bmi_status = BMI_SUCCESS
    end select
  end function noahowp_var_location

  ! Get a copy of a integer variable's values, flattened.
  function noahowp_get_int(this, name, dest) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), intent(in) :: name
    integer, intent(inout) :: dest(:)
    integer :: bmi_status

    select case(name)
!==================== UPDATE IMPLEMENTATION IF NECESSARY FOR INTEGER VARS =================
!     case("model__identification_number")
!        dest = [this%model%id]
!        bmi_status = BMI_SUCCESS
    case("ISNOW")
       dest(:) = this%model%water%ISNOW
       bmi_status = BMI_SUCCESS
    case default
       dest(:) = -1
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_get_int

  ! Get a copy of a real variable's values, flattened.
  function noahowp_get_float(this, name, dest) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), intent(in) :: name
    real, intent(inout) :: dest(:)
    integer :: bmi_status
    real    :: mm2m = 0.001       ! unit conversion mm to m     
    real    :: m2mm = 1000.       ! unit conversion m to mm
    
    call cpu_time(start_time)
    
    associate(forcing    => this%model%forcing,   &
              water      => this%model%water,     &
              energy     => this%model%energy,    &
              domain     => this%model%domain,    &
              parameters => this%model%parameters)

    select case(name)
    case("ACSNOM")
      dest = [water%ACSNOM]
      bmi_status = BMI_SUCCESS
    case("AXAJ")
      dest = [parameters%AXAJ]
      bmi_status = BMI_SUCCESS
    case("BEXP")
      dest = [parameters%bexp]
      bmi_status = BMI_SUCCESS
    case("BXAJ")
      dest = [parameters%BXAJ]
      bmi_status = BMI_SUCCESS
    case("CMC")
      dest = [water%CMC]
      bmi_status = BMI_SUCCESS
    case("CWP")
      dest = [parameters%CWP]
      bmi_status = BMI_SUCCESS
    case("DKSAT")
      dest = [parameters%dksat]
      bmi_status = BMI_SUCCESS
    case("ECAN")
      dest = [water%ECAN*domain%DT]
      bmi_status = BMI_SUCCESS
    case("ETRAN")
      dest = [water%etran*domain%DT]
      bmi_status = BMI_SUCCESS
    case("EVAPOTRANS")
      dest = [water%evapotrans]
      bmi_status = BMI_SUCCESS
    case("FIRA")
      dest = [energy%FIRA]
      bmi_status = BMI_SUCCESS
    case("FRZX")
      dest = [parameters%frzx]
      bmi_status = BMI_SUCCESS
    case("FSA")
      dest = [energy%FSA]
      bmi_status = BMI_SUCCESS
    case("FSH")
      dest = [energy%FSH]
      bmi_status = BMI_SUCCESS
    case("FSNO")
      dest = [water%FSNO]
      bmi_status = BMI_SUCCESS
    case("GH")
      dest = [energy%GH]
      bmi_status = BMI_SUCCESS
    case("HVT")
      dest = [parameters%HVT]
      bmi_status = BMI_SUCCESS
    case("KDT")
      dest = [parameters%kdt]
      bmi_status = BMI_SUCCESS
    case("LH")
      dest = [energy%LH]
      bmi_status = BMI_SUCCESS
    case("LWDN")
      dest = [forcing%lwdn]
      bmi_status = BMI_SUCCESS
    case("MFSNO")
      dest = [parameters%MFSNO]
      bmi_status = BMI_SUCCESS
    case("MP")
      dest = [parameters%MP]
      bmi_status = BMI_SUCCESS
    case("PRCPNONC")
      dest = [forcing%prcpnonc]
      bmi_status = BMI_SUCCESS
    case("Q2")
      dest = [forcing%q2]
      bmi_status = BMI_SUCCESS
    case("QINSUR")
      dest = [water%qinsur]
      bmi_status = BMI_SUCCESS
    case("QRAIN")
      dest = [water%QRAIN]
      bmi_status = BMI_SUCCESS
    case("QSEVA")
      dest = [water%qseva*m2mm]
      bmi_status = BMI_SUCCESS
    case("QSNOW")
      dest = [water%QSNOW]
      bmi_status = BMI_SUCCESS
    case("REFKDT")
      dest = [parameters%refkdt]
      bmi_status = BMI_SUCCESS
    case("RSURF_EXP")
      dest = [parameters%RSURF_EXP]
      bmi_status = BMI_SUCCESS
    case("RSURF_SNOW")
      dest = [parameters%RSURF_SNOW]
      bmi_status = BMI_SUCCESS
    case("SCAMAX")
      dest = [parameters%SCAMAX]
      bmi_status = BMI_SUCCESS    
    case("SFCPRS")
      dest = [forcing%sfcprs]
      bmi_status = BMI_SUCCESS
    case("SFCTMP")
      dest = [forcing%sfctmp]
      bmi_status = BMI_SUCCESS
    case("SLOPE")
      dest = [parameters%slope]
      bmi_status = BMI_SUCCESS
    case("SMCMAX")
      dest = [parameters%smcmax]
      bmi_status = BMI_SUCCESS
    case("SNEQV")
      dest = [water%sneqv]
      bmi_status = BMI_SUCCESS
    case("SNLIQ")
      dest = [water%SNLIQ]
      bmi_status = BMI_SUCCESS
    case("SNOWH")
      dest = [water%SNOWH]
      bmi_status = BMI_SUCCESS
    case("SNOWT_AVG")
      dest = [energy%SNOWT_AVG]
      bmi_status = BMI_SUCCESS
    case("SOLDN")
      dest = [forcing%soldn]
      bmi_status = BMI_SUCCESS
    case("TG")
      dest = [energy%tg]
      bmi_status = BMI_SUCCESS
    case("TGS")
      dest = [energy%tgs]
      bmi_status = BMI_SUCCESS
    case("TRAD")
      dest = [energy%TRAD]
      bmi_status = BMI_SUCCESS
    case("UU")
      dest = [forcing%uu]
      bmi_status = BMI_SUCCESS
    case("VCMX25")
      dest = [parameters%VCMX25]
      bmi_status = BMI_SUCCESS
    case("VV")
      dest = [forcing%vv]
      bmi_status = BMI_SUCCESS
    case("XXAJ")
      dest = [parameters%XXAJ]
      bmi_status = BMI_SUCCESS
    case default
       dest(:) = -1.0
       bmi_status = BMI_FAILURE
    end select
    end associate

    call cpu_time(end_time)
    elapsed_time = end_time - start_time
    print *, 'Time for noahowp_get_float (', trim(name), '):', elapsed_time, ' seconds'
    ! NOTE, if vars are gridded, then use:
    ! dest = reshape(this%model%temperature, [this%model%n_x*this%model%n_y]) 
  end function noahowp_get_float

  ! Get a copy of a double variable's values, flattened.
  function noahowp_get_double(this, name, dest) result (bmi_status)
    class (bmi_noahowp), intent(in) :: this
    character (len=*), intent(in) :: name
    double precision, intent(inout) :: dest(:)
    integer :: bmi_status

    !==================== UPDATE IMPLEMENTATION IF NECESSARY FOR DOUBLE VARS =================

    select case(name)
    case default
       dest(:) = -1.d0
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_get_double

   ! Get a reference to an integer-valued variable, flattened.
   function noahowp_get_ptr_int(this, name, dest_ptr) result (bmi_status)
     class (bmi_noahowp), intent(in) :: this
     character (len=*), intent(in) :: name
     integer, pointer, intent(inout) :: dest_ptr(:)
     integer :: bmi_status
     type (c_ptr) :: src
     integer :: n_elements

     call cpu_time(start_time)
     select case(name)
     case default
        bmi_status = BMI_FAILURE
     end select
     call cpu_time(end_time)
    elapsed_time = end_time - start_time
    print *, 'Time for noahowp_get_ptr_int (', trim(name), '):', elapsed_time, ' seconds'

   end function noahowp_get_ptr_int

   ! Get a reference to a real-valued variable, flattened.
   function noahowp_get_ptr_float(this, name, dest_ptr) result (bmi_status)
     class (bmi_noahowp), intent(in) :: this
     character (len=*), intent(in) :: name
     real, pointer, intent(inout) :: dest_ptr(:)
     integer :: bmi_status
     type (c_ptr) :: src
     integer :: n_elements
     
     call cpu_time(start_time)
     select case(name)
     case default
        bmi_status = BMI_FAILURE
     end select

     call c_f_pointer(src, dest_ptr, [n_elements])
     call cpu_time(end_time)
     elapsed_time = end_time - start_time
     print *, 'Time for noahowp_set_float (', trim(name), '):', elapsed_time, ' seconds'
   end function noahowp_get_ptr_float

   ! Get a reference to an double-valued variable, flattened.
   function noahowp_get_ptr_double(this, name, dest_ptr) result (bmi_status)
     class (bmi_noahowp), intent(in) :: this
     character (len=*), intent(in) :: name
     double precision, pointer, intent(inout) :: dest_ptr(:)
     integer :: bmi_status
     type (c_ptr) :: src
     integer :: n_elements

     select case(name)
     case default
        bmi_status = BMI_FAILURE
     end select
   end function noahowp_get_ptr_double

   ! Get values of an integer variable at the given locations.
   function noahowp_get_at_indices_int(this, name, dest, inds) &
        result (bmi_status)
     class (bmi_noahowp), intent(in) :: this
     character (len=*), intent(in) :: name
     integer, intent(inout) :: dest(:)
     integer, intent(in) :: inds(:)
     integer :: bmi_status
!     type (c_ptr) src
!     integer, pointer :: src_flattened(:)
!     integer :: i, n_elements

     select case(name)
     case default
        bmi_status = BMI_FAILURE
     end select
   end function noahowp_get_at_indices_int

   ! Get values of a real variable at the given locations.
   function noahowp_get_at_indices_float(this, name, dest, inds) &
        result (bmi_status)
     class (bmi_noahowp), intent(in) :: this
     character (len=*), intent(in) :: name
     real, intent(inout) :: dest(:)
     integer, intent(in) :: inds(:)
     integer :: bmi_status
!     type (c_ptr) src
!     real, pointer :: src_flattened(:)
!     integer :: i, n_elements

     select case(name)
!     case("plate_surface__temperature")
!        src = c_loc(this%model%temperature(1,1))
!        call c_f_pointer(src, src_flattened, [this%model%n_y * this%model%n_x])
!        n_elements = size(inds)
!        do i = 1, n_elements
!           dest(i) = src_flattened(inds(i))
!        end do
!        bmi_status = BMI_SUCCESS
     case default
        bmi_status = BMI_FAILURE
     end select
   end function noahowp_get_at_indices_float

   ! Get values of a double variable at the given locations.
   function noahowp_get_at_indices_double(this, name, dest, inds) &
        result (bmi_status)
     class (bmi_noahowp), intent(in) :: this
     character (len=*), intent(in) :: name
     double precision, intent(inout) :: dest(:)
     integer, intent(in) :: inds(:)
     integer :: bmi_status
     type (c_ptr) src
     double precision, pointer :: src_flattened(:)
     integer :: i, n_elements

     select case(name)
     case default
        bmi_status = BMI_FAILURE
     end select
   end function noahowp_get_at_indices_double

  ! Set new integer values.
  function noahowp_set_int(this, name, src) result (bmi_status)
    class (bmi_noahowp), intent(inout) :: this
    character (len=*), intent(in) :: name
    integer, intent(in) :: src(:)
    integer :: bmi_status

    !==================== UPDATE IMPLEMENTATION IF NECESSARY FOR INTEGER VARS =================

    select case(name)
!     case("model__identification_number")
!        this%model%id = src(1)
!        bmi_status = BMI_SUCCESS
    case default
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_set_int

  ! Set new real values.
  function noahowp_set_float(this, name, src) result (bmi_status)
    class (bmi_noahowp), intent(inout) :: this
    character (len=*), intent(in) :: name
    real, intent(in) :: src(:)
    integer :: bmi_status
    real    :: mm2m = 0.001       ! unit conversion mm to m     
    real    :: m2mm = 1000.       ! unit conversion m to mm

    associate(forcing    => this%model%forcing,   &
              water      => this%model%water,     &
              energy     => this%model%energy,    &
              domain     => this%model%domain,    &
              parameters => this%model%parameters)

    select case(name)
    case("AXAJ")
      parameters%AXAJ = src(1)
      bmi_status = BMI_SUCCESS
    case("BEXP")
      parameters%bexp(:) = src(:)
      bmi_status = BMI_SUCCESS
    case("BXAJ")
      parameters%BXAJ = src(1)
      bmi_status = BMI_SUCCESS
    case("CWP")
      parameters%CWP = src(1)
      bmi_status = BMI_SUCCESS
    case("DKSAT")
      parameters%dksat(:) = src(:)
      parameters%kdt     = parameters%refkdt * parameters%dksat(1) / parameters%refdk
      bmi_status = BMI_SUCCESS
    case("ETRAN")
      water%etran = src(1) / domain%DT
      bmi_status = BMI_SUCCESS
    case("EVAPOTRANS")
      water%evapotrans = src(1)
      bmi_status = BMI_SUCCESS
    case("FRZX")
      parameters%FRZX = src(1)
      bmi_status = BMI_SUCCESS
    case("HVT")
      parameters%HVT = src(1)
      bmi_status = BMI_SUCCESS
    case("KDT")
      parameters%KDT = src(1)
      bmi_status = BMI_SUCCESS
    case("LWDN")
      forcing%lwdn = src(1)
      bmi_status = BMI_SUCCESS
    case("MFSNO")
      parameters%MFSNO = src(1)
      bmi_status = BMI_SUCCESS
    case("MP")
      parameters%MP = src(1)
      bmi_status = BMI_SUCCESS
    case("PRCPNONC")
      forcing%prcpnonc = src(1)
      bmi_status = BMI_SUCCESS
    case("Q2")
      forcing%q2 = src(1)
      bmi_status = BMI_SUCCESS
    case("QINSUR")
      water%qinsur = src(1)
      bmi_status = BMI_SUCCESS
    case("QSEVA")
      water%qseva = src(1) * mm2m 
      bmi_status = BMI_SUCCESS
    case("REFKDT")
      parameters%refkdt = src(1)
      parameters%kdt     = parameters%refkdt * parameters%dksat(1) / parameters%refdk
      bmi_status = BMI_SUCCESS
    case("RSURF_EXP")
      parameters%RSURF_EXP = src(1)
      bmi_status = BMI_SUCCESS
    case("RSURF_SNOW")
      parameters%RSURF_SNOW = src(1)
      bmi_status = BMI_SUCCESS
    case("SCAMAX")
      parameters%SCAMAX = src(1)
      bmi_status = BMI_SUCCESS
    case("SFCPRS")
      forcing%sfcprs = src(1)
      bmi_status = BMI_SUCCESS
    case("SFCTMP")
      forcing%sfctmp = src(1)
      bmi_status = BMI_SUCCESS
    case("SLOPE")
      parameters%slope = src(1)
      bmi_status = BMI_SUCCESS
    case("SMCMAX")
      parameters%smcmax(:) = src(:)
      parameters%frzx      = 0.15 * (parameters%smcmax(1) / parameters%smcref(1)) * (0.412 / 0.468)
      bmi_status = BMI_SUCCESS
    case("SNEQV")
      water%sneqv = src(1)
      bmi_status = BMI_SUCCESS
    case("SOLDN")
      forcing%soldn = src(1)
      bmi_status = BMI_SUCCESS
    case("TG")
      energy%tg = src(1)
      bmi_status = BMI_SUCCESS
    case("TGS")
      energy%tgs = src(1)
      bmi_status = BMI_SUCCESS
    case("UU")
      forcing%uu = src(1)
      bmi_status = BMI_SUCCESS
    case("VCMX25")
      parameters%VCMX25 = src(1)
      bmi_status = BMI_SUCCESS
    case("VV")
      forcing%vv = src(1)
      bmi_status = BMI_SUCCESS
    case("XXAJ")
      parameters%XXAJ = src(1)
      bmi_status = BMI_SUCCESS
    case default
       bmi_status = BMI_FAILURE
    end select
    end associate
    ! NOTE, if vars are gridded, then use:
    ! this%model%temperature = reshape(src, [this%model%n_y, this%model%n_x])
  end function noahowp_set_float

  ! Set new double values.
  function noahowp_set_double(this, name, src) result (bmi_status)
    class (bmi_noahowp), intent(inout) :: this
    character (len=*), intent(in) :: name
    double precision, intent(in) :: src(:)
    integer :: bmi_status

    !==================== UPDATE IMPLEMENTATION IF NECESSARY FOR DOUBLE VARS =================

    select case(name)
    case default
       bmi_status = BMI_FAILURE
    end select
  end function noahowp_set_double

   ! Set integer values at particular locations.
   function noahowp_set_at_indices_int(this, name, inds, src) &
        result (bmi_status)
     class (bmi_noahowp), intent(inout) :: this
     character (len=*), intent(in) :: name
     integer, intent(in) :: inds(:)
     integer, intent(in) :: src(:)
     integer :: bmi_status
!     type (c_ptr) dest
!     integer, pointer :: dest_flattened(:)
!     integer :: i

     select case(name)
     case default
        bmi_status = BMI_FAILURE
     end select
   end function noahowp_set_at_indices_int

   ! Set real values at particular locations.
   function noahowp_set_at_indices_float(this, name, inds, src) &
        result (bmi_status)
     class (bmi_noahowp), intent(inout) :: this
     character (len=*), intent(in) :: name
     integer, intent(in) :: inds(:)
     real, intent(in) :: src(:)
     integer :: bmi_status
!     type (c_ptr) dest
!     real, pointer :: dest_flattened(:)
!     integer :: i

     select case(name)
!     case("plate_surface__temperature")
!        dest = c_loc(this%model%temperature(1,1))
!        call c_f_pointer(dest, dest_flattened, [this%model%n_y * this%model%n_x])
!        do i = 1, size(inds)
!           dest_flattened(inds(i)) = src(i)
!        end do
!        bmi_status = BMI_SUCCESS
     case default
        bmi_status = BMI_FAILURE
     end select
   end function noahowp_set_at_indices_float

   ! Set double values at particular locations.
   function noahowp_set_at_indices_double(this, name, inds, src) &
        result (bmi_status)
     class (bmi_noahowp), intent(inout) :: this
     character (len=*), intent(in) :: name
     integer, intent(in) :: inds(:)
     double precision, intent(in) :: src(:)
     integer :: bmi_status
!     type (c_ptr) dest
!     double precision, pointer :: dest_flattened(:)
!     integer :: i

     select case(name)
     case default
        bmi_status = BMI_FAILURE
     end select
   end function noahowp_set_at_indices_double

   ! A non-BMI helper routine to advance the model by a fractional time step.
!   subroutine update_frac(this, time_frac)
!     class (bmi_noahowp), intent(inout) :: this
!     double precision, intent(in) :: time_frac
!     real :: time_step
!
!     if (time_frac > 0.0) then
!        time_step = this%model%dt
!        this%model%dt = time_step*real(time_frac)
!        call advance_in_time(this%model)
!        this%model%dt = time_step
!     end if
!   end subroutine update_frac
!
!   ! A non-BMI procedure for model introspection.
!   subroutine print_model_info(this)
!     class (bmi_noahowp), intent(in) :: this
!
!     call print_info(this%model)
!   end subroutine print_model_info
#ifdef NGEN_ACTIVE
  function register_bmi(this) result(bmi_status) bind(C, name="register_bmi")
   use, intrinsic:: iso_c_binding, only: c_ptr, c_loc, c_int
   use iso_c_bmif_2_0
   implicit none
   type(c_ptr) :: this ! If not value, then from the C perspective `this` is a void**
   integer(kind=c_int) :: bmi_status
   !Create the model instance to use
   type(bmi_noahowp), pointer :: bmi_model
   !Create a simple pointer wrapper
   type(box), pointer :: bmi_box

   !allocate model
   allocate(bmi_noahowp::bmi_model)
   !allocate the pointer box
   allocate(bmi_box)

   !associate the wrapper pointer the created model instance
   bmi_box%ptr => bmi_model

   if( .not. associated( bmi_box ) .or. .not. associated( bmi_box%ptr ) ) then
    bmi_status = BMI_FAILURE
   else
    !Return the pointer to box
    this = c_loc(bmi_box)
    bmi_status = BMI_SUCCESS
   endif
 end function register_bmi
#endif
end module bminoahowp
