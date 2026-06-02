using Microsoft.EntityFrameworkCore;
using STEMMA.Application.Auth.UseCases;
using STEMMA.Application.Cadastro.Tutores.UseCases;
using STEMMA.Application.Cadastro.UseCases.Pet;
using STEMMA.Application.Cadastro.UseCases.Pets;
using STEMMA.Application.Cadastro.Veterinarios.UseCases;
using STEMMA.Application.Consultas.Disponibilidades.UseCases;
using STEMMA.Application.Consultas.UseCases;
using STEMMA.Domain.Cadastro.Repositories;
using STEMMA.Domain.Consultas.Repositories;
using STEMMA.Infrastructure.Persistence.Context;
using STEMMA.Infrastructure.Persistence.Repositories;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<StemmaDbContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"));
});

// Repositories
builder.Services.AddScoped<ITutorRepository, TutorRepository>();

builder.Services.AddScoped<IPetRepository, PetRepository>();

builder.Services.AddScoped<IVeterinarioRepository, VeterinarioRepository>();

builder.Services.AddScoped<IConsultaRepository, ConsultaRepository>();

builder.Services.AddScoped<IDisponibilidadeRepository, DisponibilidadeRepository>();

builder.Services.AddScoped<IProntuarioRepository, ProntuarioRepository>();

// Tutor
builder.Services.AddScoped<ICreateTutorUseCase, CreateTutorUseCase>();

builder.Services.AddScoped<GetTutorByIdUseCase>();

builder.Services.AddScoped<ListTutorsUseCase>();

builder.Services.AddScoped<UpdateTutorUseCase>();

builder.Services.AddScoped<DeleteTutorUseCase>();

// Pet
builder.Services.AddScoped<CreatePetUseCase>();

builder.Services.AddScoped<GetPetByIdUseCase>();

builder.Services.AddScoped<ListPetsUseCase>();

builder.Services.AddScoped<UpdatePetUseCase>();

builder.Services.AddScoped<InactivatePetUseCase>();

// Veterinário
builder.Services.AddScoped<CreateVeterinarioUseCase>();

builder.Services.AddScoped<GetVeterinarioByIdUseCase>();

builder.Services.AddScoped<ListVeterinariosUseCase>();

builder.Services.AddScoped<UpdateVeterinarioUseCase>();

builder.Services.AddScoped<DeleteVeterinarioUseCase>();

// Disponibilidade
builder.Services.AddScoped<CreateDisponibilidadeUseCase>();

builder.Services.AddScoped<ListDisponibilidadesUseCase>();

builder.Services.AddScoped<ListDisponibilidadesPorVeterinarioUseCase>();

builder.Services.AddScoped<DeleteDisponibilidadeUseCase>();

builder.Services.AddScoped<ListHorariosDisponiveisUseCase>();

builder.Services.AddScoped<CreateAgendaDisponibilidadeUseCase>();

// Consulta
builder.Services.AddScoped<CreateConsultationUseCase>();

builder.Services.AddScoped<UpdateConsultationUseCase>();

builder.Services.AddScoped<CancelConsultationUseCase>();

builder.Services.AddScoped<CompleteConsultationUseCase>();

builder.Services.AddScoped<AddMedicalRecordUseCase>();

builder.Services.AddScoped<GetConsultationByIdUseCase>();

builder.Services.AddScoped<ListConsultationsUseCase>();

builder.Services.AddScoped<ListConsultationsByPetUseCase>();

builder.Services.AddScoped<StartConsultationUseCase>();

builder.Services.AddScoped<ListClosedConsultationsUseCase>();

// Auth
builder.Services.AddScoped<LoginUseCase>();

// CORS
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