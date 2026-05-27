using Microsoft.EntityFrameworkCore;
using STEMMA.Infrastructure.Persistence.Context;
using STEMMA.Domain.Cadastro.Repositories;
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

builder.Services.AddScoped<ITutorRepository, TutorRepository>();

builder.Services.AddScoped<IPetRepository, PetRepository>();

builder.Services.AddScoped<CreateTutorUseCase>();

builder.Services.AddScoped<CreatePetUseCase>();

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

app.Run();