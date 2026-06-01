using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Requests;

namespace STEMMA.Application.Cadastro.Veterinarios.UseCases;

public interface ICreateVeterinarioUseCase
{
    Task<Guid> ExecuteAsync(
        CreateVeterinarioRequest request);
}