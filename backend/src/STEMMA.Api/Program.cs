using Microsoft.EntityFrameworkCore;
using STEMMA.Application.Auth.UseCases;
using STEMMA.Application.Cadastro.Tutores.UseCases;
using STEMMA.Application.Cadastro.UseCases.Pets;
using STEMMA.Application.Cadastro.Veterinarios.Services;
using STEMMA.Application.Cadastro.Veterinarios.UseCases;
using STEMMA.Domain.Cadastro.Repositories;
using STEMMA.Infrastructure.Persistence.Context;
using STEMMA.Infrastructure.Persistence.Repositories;
using STEMMA.Domain.Consultas.Repositories;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<StemmaDbContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"));
});

builder.Services.AddScoped<ITutorRepository, TutorRepository>();

builder.Services.AddScoped<IPetRepository, PetRepository>();

builder.Services.AddScoped<IVeterinarioRepository, VeterinarioRepository>();

builder.Services.AddScoped<ICreateVeterinarioUseCase, CreateVeterinarioUseCase>();

builder.Services.AddScoped<IVeterinarioService, VeterinarioService>();

builder.Services.AddScoped<ICreateTutorUseCase, CreateTutorUseCase>();

builder.Services.AddScoped<GetTutorByIdUseCase>();

builder.Services.AddScoped<ListTutorsUseCase>();

builder.Services.AddScoped<UpdateTutorUseCase>();

builder.Services.AddScoped<DeleteTutorUseCase>();

builder.Services.AddScoped<IConsultaRepository, ConsultaRepository>();

builder.Services.AddScoped<CreateTutorUseCase>();

builder.Services.AddScoped<CreatePetUseCase>();

builder.Services.AddScoped<GetVeterinarioByIdUseCase>();

builder.Services.AddScoped<ListVeterinariosUseCase>();

builder.Services.AddScoped<UpdateVeterinarioUseCase>();

builder.Services.AddScoped<DeleteVeterinarioUseCase>();

builder.Services.AddScoped<LoginUseCase>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy =>
        {
            policy
                .AllowAnyOrigin()
                .AllowAnyHeader()
                .AllowAnyMethod();
        });
});



var app = builder.Build();

app.UseSwagger();

app.UseSwaggerUI();

app.UseCors("AllowAll");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider
        .GetRequiredService<StemmaDbContext>();

    context.Database.EnsureCreated();
}

app.Run();