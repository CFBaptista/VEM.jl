@testsnippet TestSimulationTime begin
    # GIVEN

    expected_start_time = 0.0
    expected_time_step = 0.1
    expected_number_of_steps = 10
    expected_current_step = 0

    # WHEN

    time = SimulationTime(expected_time_step, expected_number_of_steps)
end

@testitem "Construct SimulationTime with default values" setup = [TestSimulationTime] begin
    # WHEN

    start_time = time.start_time
    time_step = time.time_step
    number_of_steps = time.number_of_steps
    current_step = time.current_step

    # THEN

    @test start_time == expected_start_time
    @test time_step == expected_time_step
    @test number_of_steps == expected_number_of_steps
    @test current_step == expected_current_step
end

@testitem "Get current time" setup = [TestSimulationTime] begin
    # WHEN

    actual_current_time = current_time(time)

    # THEN

    @test actual_current_time == expected_start_time
end

@testitem "Get end time" setup = [TestSimulationTime] begin
    # WHEN

    actual_end_time = end_time(time)

    # THEN

    @test actual_end_time == expected_start_time + expected_number_of_steps * expected_time_step
end

@testitem "Update time" setup = [TestSimulationTime] begin
    # WHEN

    advance!(time)
    actual_current_step = time.current_step
    actual_current_time = current_time(time)

    # THEN

    @test actual_current_step == expected_current_step + 1
    @test actual_current_time ==
        expected_start_time + (expected_current_step + 1) * expected_time_step
end

@testitem "Simulation should run if current step is less than number of steps" setup = [
    TestSimulationTime
] begin
    # WHEN

    should_run = running(time)

    # THEN

    @test should_run == true
end

@testitem "Simulation should not run if current step is equal to number of steps" setup = [
    TestSimulationTime
] begin
    # WHEN

    while running(time)
        advance!(time)
    end

    # THEN

    @test running(time) == false
    @test time.current_step == expected_number_of_steps
end

@testitem "Construct SimulationTime with non-default values" begin
    # GIVEN

    expected_start_time = 3.5
    expected_time_step = 0.25
    expected_number_of_steps = 7
    expected_current_step = 2

    # WHEN

    time = SimulationTime(
        expected_time_step,
        expected_number_of_steps;
        start_time=expected_start_time,
        current_step=expected_current_step,
    )

    start_time = time.start_time
    time_step = time.time_step
    number_of_steps = time.number_of_steps
    current_step = time.current_step

    # THEN

    @test start_time == expected_start_time
    @test time_step == expected_time_step
    @test number_of_steps == expected_number_of_steps
    @test current_step == expected_current_step
end